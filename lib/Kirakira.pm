package Kirakira;
use strict;
use warnings;
use utf8;
use lib 'lib';

use Kirakira::DB;
use Kirakira::Throttle;
use Digest::MD5;
use Encode qw/ _utf8_on _utf8_off /;

use constant {
    KIRAKIRA_TABLE =>{
        0 => '☆',
        1 => '¨',
        2 => '∵',
        3 => '*',
        4 => '゜',
        5 => 'o',
        6 => '∮',
        7 => '+',
        8 => '★',
        9 => '｡',
        a => ':',
        b => 'ﾟ',
        c => '♪',
        d => 'о',
        e => '.',
        f => '・',
    },
    MAX_WORD_LENGTH => 400,
    MINIMUN_KIRAKIRA_LENGTH => 12,
    KIRAKIRA_LENGTH => 16,
    ERROR_MESSAGE   => '変換できなかったよ(´･ω･`)',
    RESTRICTED_MESSAGE => '連投制限だよ(´･ω･`)',
};

sub encode {
    my $class = shift;
    my $word = substr(shift, 0, MAX_WORD_LENGTH);

    my $throttle = Kirakira::Throttle->new();
    return RESTRICTED_MESSAGE if $throttle->is_restricted();

    Encode::_utf8_off($word);
    my $hash_hex = Digest::MD5->md5_hex($word);

    Kirakira::DB->insert({
        hash => $hash_hex,
        word => $word,
    });

    my $kirakira = $class->hash2kirakira($hash_hex);

    $throttle->call();
    return $kirakira;
}

sub decode {
    my $class = shift;
    my $kirakira = shift;

    my $throttle = Kirakira::Throttle->new();
    return RESTRICTED_MESSAGE if $throttle->is_restricted();

    my @kirakira_allowed_word = values %{KIRAKIRA_TABLE()};
    my $cleaned_kirakira = s/^[@kirakira_allowed_word]//g;

    my $hash_hex = $class->kirakira2hash(
        $cleaned_kirakira
    );

    return ERROR_MESSAGE if length $kirakira < MINIMUN_KIRAKIRA_LENGTH;

    my $word = Kirakira::DB->select_word({
        hash => $hash_hex,
    });
    Encode::_utf8_on($word);
    $throttle->call();
    return $word || ERROR_MESSAGE;
}

sub hash2kirakira {
    my $class = shift;
    my $hash = shift;

    my $kirakira = $hash;
    for( keys KIRAKIRA_TABLE()){
        my $kira = KIRAKIRA_TABLE()->{$_};
        $kirakira =~ s/$_/$kira/g;
    }

    return substr($kirakira, 0, KIRAKIRA_LENGTH);
}

sub kirakira2hash {
    my $class = shift;
    my $kirakira = shift;

    my $hash = $kirakira;
    for( keys KIRAKIRA_TABLE()){
        my $kira = quotemeta(KIRAKIRA_TABLE()->{$_});
        $hash =~ s/$kira/$_/g;
    }

    return $hash;
}

1;
