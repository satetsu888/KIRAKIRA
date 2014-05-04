use strict;
use warnings;
use utf8;
use lib 'lib';

use Mojolicious::Lite;
use MojoX::JSON::RPC::Service;
use Kirakira;

my $svc = MojoX::JSON::RPC::Service->new;

$svc->register(
    'encode',
    sub {
        my $params = shift;
        return Kirakira->encode($params->{word});
    },
);

$svc->register(
    'decode',
    sub {
        my $params = shift;
        return Kirakira->decode($params->{kirakira});
    },
);

plugin 'json_rpc_dispatcher' => {
    services => {
        '/jsonrpc' => $svc,
    }
};

get '/' => sub {
    my $self = shift;
    my $mode = 'default';

    $self->stash(
        'word'     => '',
        'kirakira' => '',
    );

    $self->render();
} => 'index';

get '/encode' => sub {
    shift->redirect_to('/');
};

get '/decode' => sub {
    shift->redirect_to('/');
};

post '/encode' => sub {
    my $self = shift;
    my $mode = 'encode';
    my $word = $self->param('word');
    my $kirakira = Kirakira->encode($word);

    $self->stash(
        'word'     => $word     || '',
        'kirakira' => $kirakira || '',
    );

    $self->render();
} => 'index';

post '/decode' => sub {
    my $self = shift;
    my $mode = 'decode';
    my $kirakira = $self->param('kirakira');
    my $word = Kirakira->decode($kirakira);

    $self->stash(
        'word'     => $word     || '',
        'kirakira' => $kirakira || '',
    );

    $self->render();
} => 'index';


app->start;


__DATA__
@@ index.html.ep

<!DOCTYPE html> 
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,  initial-scale=1">
<title>*:.。.:*゜キラキラ暗号゜*:.。.:*</title>
<link href="http://code.jquery.com/mobile/1.0/jquery.mobile-1.0.min.css" rel="stylesheet" type="text/css"/>
<style type="text/css">
#page div .ui-grid-a ul li {
	font-size: xx-small;
}
#page div .ui-grid-a h6 {
	margin-bottom: 0px;
}
#page div .ui-grid-a ul {
	margin-top: 5px;
}
</style>
<script src="http://code.jquery.com/jquery-1.6.4.min.js" type="text/javascript"></script>
<script type="text/javascript">
  $(document).bind("mobileinit", function(){
    $.mobile.ajaxFormsEnabled = false;
    $.mobile.ajaxEnabled = false;
  });
</script>
<script src="http://code.jquery.com/mobile/1.0/jquery.mobile-1.0.min.js" type="text/javascript"></script>
<script language="JavaScript" type="text/JavaScript">
function CopyText(arg){
    var obj=document.getElementsByName(arg)[0];
    obj.selectionStart=0;
	obj.selectionEnd=obj.value.length;
    document.execCommand("copy");
}
//-->
</script>
<script>
(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
})(window,document,'script','//www.google-analytics.com/analytics.js','ga');

ga('create', 'UA-50183657-2', 'kirakira-ango.com');
</script>
<script>
/**
* Google アナリティクスでアウトバウンド リンクのクリックをトラッキングする関数。
* この関数では有効な URL 文字列を引数として受け取り、その URL 文字列を
* イベントのラベルとして使用する。
*/
var trackOutboundLink = function(url) {
    ga('send', 'event', 'outbound', 'click', url, {'hitCallback':
        function () {
            document.location = url;
        }
    });
}
</script>

</head> 
<body>

<div data-role="page" id="page" data-theme="c">
	<div data-role="header" align="center">
		<img src="http://satetsu888.com/kirakira/logo.png" width="225" height="79">
	</div>
	<div data-role="content">
<a href="https://twitter.com/share" class="twitter-share-button" data-url="http://kirakira-ango.com/" data-lang="ja" data-related="kirakira_ango" data-hashtags="kirakira">ツイート</a>
<script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+'://platform.twitter.com/widgets.js';fjs.parentNode.insertBefore(js,fjs);}}(document, 'script', 'twitter-wjs');</script>
        <p>キラキラ暗号は日本語の文章をキラキラした記号へと暗号化するサービスです。<br>たとえば、「こんにちわ」は「☆.・∮・｡o・｡゜оﾟ∵*+★∮・☆*☆ﾟ¨+∮*о∵∵゜ﾟﾟ」のように変換されます。<br>暗号はこのサイトでだけ解くことができます。</p>
    <p>
        iPhoneアプリもよろしくね
        <a href="#" onclick="trackOutboundLink('https://itunes.apple.com/jp/app/kirakira-an-hao/id869763054?mt=8&uo=4'); return false;" target="itunes_store" style="display:inline-block;overflow:hidden;background:url(https://linkmaker.itunes.apple.com/htmlResources/assets/ja_jp//images/web/linkmaker/badge_appstore-lrg.png) no-repeat;width:135px;height:40px;@media only screen{background-image:url(https://linkmaker.itunes.apple.com/htmlResources/assets/ja_jp//images/web/linkmaker/badge_appstore-lrg.svg);}"></a>
    </p>
	  <div class="ui-grid-a">
        <form method="POST" action="./encode">
	    <div class="ui-block">
          <input type="text" name="word" value="<%= $word %>" placeholder="暗号化したい文章をいれてね" />
        </div>
	    <div class="ui-block">
	      <input type="submit" value="暗号化する.｡.*:+☆" data-icon="check" />
        </div>
        </form>
      </div>
      <div class="ui-grid-a">
        <form method="POST" action="./decode">
	      <div class="ui-block">
            <input type="text" name="kirakira" value="<%= $kirakira %>" placeholder="暗号を解きたい記号をいれてね"/>
        </div>
        <div class="ui-block">
            <a href="https://twitter.com/share" class="twitter-share-button" data-url="http://kirakira-ango.com/" data-text="<%= $kirakira %>" data-lang="ja" data-size="large" data-related="kirakira_ango" data-count="none" data-hashtags="kirakira">キラキラをツイートする</a>
            <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+'://platform.twitter.com/widgets.js';fjs.parentNode.insertBefore(js,fjs);}}(document, 'script', 'twitter-wjs');</script>
        </div>
        <div class="ui-block">
            <input type="button" name="Copy" value="全選択.:*゜:。:." onClick="CopyText('kirakira');">
        </div>
        <div class="ui-block">
            <input type="submit" value="暗号を解く*:･'ﾟ☆" data-icon="check" />
        </div>
        </form>
      </div>
      <div class="ui-grid-a">
        <h6>利用上の注意</h6>
        <ul>
          <li>パスワードなど大切な情報の暗号化に利用しないでください。</li>
          <li>暗号化したデータが必ず復号できることを保障しません。</li>
          <li>予告なくサービスを停止することがありますのでご了承ください。</li>
        </ul>
      </div>
    </div>
	<div data-role="footer">
		<h4></h4>
	</div>
</div>
</body>
</html>
