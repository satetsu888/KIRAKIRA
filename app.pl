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
    use Data::Dumper;
    warn Dumper $kirakira;
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
<title>キラキラ暗号</title>
<link href="http://code.jquery.com/mobile/1.0/jquery.mobile-1.0.min.css" rel="stylesheet" type="text/css"/>
<script src="http://code.jquery.com/jquery-1.6.4.min.js" type="text/javascript"></script>
<script src="http://code.jquery.com/mobile/1.0/jquery.mobile-1.0.min.js" type="text/javascript"></script>
</head> 
<body> 

<div data-role="page" id="page">
<div data-role="header">
		<h1>キラキラ暗号</h1>
	</div>
	<div data-role="content">
    <p>キラキラ暗号は日本語の文章をキラキラした記号へと暗号化するサービスです</p>
    <p>たとえば、「こんにちわ」は「☆.・∮・｡o・｡゜оﾟ∵*+★∮・☆*☆ﾟ¨+∮*о∵∵゜ﾟﾟ」のように変換されます
    <div class="ui-grid-a">
    <form method="POST" action="./encode">
      <div class="ui-block-a">
      
        <textarea cols="40" rows="8" name="word" placeholder="暗号化したい文章をいれてね"><%= $word %></textarea>
      </div>
      <div class="ui-block-b">
        <input type="submit" value="暗号化する" data-icon="arrow-d" />
      </div>
      </form>
      <form method="POST" action="./decode">
      <div class="ui-block-a">
        <textarea cols="40" rows="8" name="kirakira" placeholder="暗号を解きたい記号を入れてね"><%= $kirakira %></textarea>
      </div>
      <div class="ui-block-b">
        <input type="submit" value="暗号を解く" data-icon="arrow-u" />
      </div>
      </form>
    </div>
<div data-role="fieldcontain">

<div data-role="footer">
    <h6></h6>
	</div>
</div>
</body>
</html>
