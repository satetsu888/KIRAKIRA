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
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>KIRAKIRA暗号</title>
</head>
<body>
<form action='./encode' method="POST">
    <textarea name="word" style="width:500px;height:100px" placeholder="暗号化したいメッセージを入力してください"><%= $word %></textarea>
    <input type="submit" value="変換">
</form>

<form action='./decode' method="POST">
    <textarea name="kirakira" style="width:500px;height:25px;" placeholder="日本語に変換したい記号を入力してください"><%= $kirakira %></textarea>
    <input type="submit" value="変換">
</form>
</body>
</html>
