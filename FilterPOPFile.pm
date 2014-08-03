package FilterPOPFile;
use XMLRPC::Lite;
use File::Temp ();
use Encode;
use Moose;

has 'server_socket' => (
	is => 'rw',
	isa => 'XMLRPC::Lite',
	builder => 'server_build',
);

has 'proxy' => (
	isa => 'Str',
	is => 'ro',
);

has 'tmpdir' => (
	isa => 'Str',
	is => 'ro',
);

has 'training' => (
	isa => 'Int',
	is => 'ro',
);

has 'encoding' => (
	isa => 'Str',
	is	=> 'ro',
	default => 'euc-jp',
);

has 'content' => (
	isa => 'HashRef',
	is  => 'rw',
	default => sub{ {} },
);

__PACKAGE__->meta->make_immutable;

no Moose;

sub server_build {
	 my $self = shift;
   my $popfile_tempdir = File::Temp::tempdir(
        $self->tmpdir,
        CLEANUP => 1,
	 ); 
	 XMLRPC::Lite->proxy($self->proxy);
}

sub filter {
	my $self = shift;

	my $filename = $self->_write_tmpfile(
			$self->content->{title}, 
			$self->content->{text},
		  $self->content->{url},
			$self->tmpdir,
			$self->encoding,
	);

	my $socket = $self->server_socket;
	my $popfile_session = $socket->call(
		'POPFile/API.get_session_key',
		'admin',
		'',
	)->result;

	my $training = $self->training || 0;

	my $bucket;
	if ($training) {
		$bucket = $socket->call(
			'POPFile/API.handle_message',
			$popfile_session,
			$filename,
			"$filename.out"
			)->result;
	} else {
		$bucket = $socket->call(
			'POPFile/API.classify',
			$popfile_session,
			$filename
		)->result;
	}

	$self->_close($popfile_session);

	decode('ascii',$bucket);
	return $bucket;
}

sub _close {
	my ($self, $popfile_session)  = @_;
	$self->server_socket->call(
		'POPFile/API.release_session_key',
		$popfile_session
	);
}

sub _write_tmpfile {
	my ($self, $title, $text, $url, $tmpdir, $encoding) = @_;

	my ($fh, $filename) = File::Temp::tempfile(
		DIR => $tmpdir,
	);

	print $fh
		'From: (', $url, ') <tumblr@localhost>', "\n",
		'To: <tumblr@localhost>', "\n",
		'Subject: ', encode($encoding, $title), "\n\n",
		encode($encoding, $text), "\n";
	
	close $fh;

	return $filename;
}

1;
