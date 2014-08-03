#! /usr/bin/perl
use strict;
use warnings;
use Encode;
use feature 'say';
use utf8;
use FilterPOPFile;

my $url = "http://nlab.itmedia.co.jp/nl/articles/1408/02/news003.html";
my $title = "「ニンジャスレイヤー」原作者ブラッドレー・ボンド＆フィリップ・N・モーゼズにインタビュー[1/2] - ねとらぼ";
my $text = "日本では今、あるノベル作品がTwitterをにぎわせている。それは、「Aieeee! 」が口癖の忍者が活躍するサイバーパンクニンジャ活劇「ニンジャスレイヤー」だ。Twitter上でストーリーをリアルタイム更新するという、独特の連載形式で、現在4万7000以上のフォロワーを獲得している（英語版はTokyoOtakuMode（TOM）で連載中）。

　人気のあまりついにアニメーション化が決定し、今年4月に発表された。制作を手がけるのは、「リトル・ウィッチ・アカデミア」や「キルラキル」で話題を集めるスタジオトリガー。ノベル版がアニメになってどんな変貌を遂げるのか。日に日に周囲の期待が高まっている。

　7月3日には、Anime Expo2014（アメリカ、ロサンゼルス）にてアニメ版の第1弾PVを世界最速公開した。今回は、そんな「ニンジャスレイヤー」の原作となる小説版を手がけた2人、ブラッドレー・ボンドとフィリップ・ニンジャ・モーゼズに話をうかがった。

──　お二人の自己紹介をお願いします。これまでの簡単な経歴、ニンジャスレイヤーではどのような部分を担当したか、現在のお仕事の状況を教えて下さい。

ボ　ドーモ、ブラッドレー・ボンドです。

モ　ドーモ、フィリップ・ニンジャ・モーゼズです。我々の詳細なプロフィールはお答えできません。何故なら我々は常に、ニンジャによる攻撃や盗聴の脅威にさらされているからです。";


   my $proxy = 'http://localhost:8086/RPC2';
   my $tmpdir = '/home/toshi/Github/perl/FilterPOPFile/popfileXXXX';
	 my $training = 1;

   my $popfile = FilterPOPFile->new(
		proxy => $proxy,
		tmpdir => $tmpdir,
		training => $training,
	);
 
	$popfile->server_socket;

	my $content = {
		title => $title,
		text  => $text,
		url		=> $url,
	};

	$popfile->content( $content);

 my $res = $popfile->filter;

 
  say $res;
