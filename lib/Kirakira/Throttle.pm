package Kirakira::Throttle;
use strict;
use warnings;

use parent 'Class::Accessor::Fast';
__PACKAGE__->mk_accessors(qw/ cache ip /);

use Cache::Memcached::Fast;

use Kirakira::Config;

my $THROTTLE = [
    {
        type   => 'short',
        expire => 10,
        count  => 5,
    },
    {
        type   => 'hour',
        expire => 60 * 60 * 1,
        count  => 30,
    },
    {
        type   => 'harf-day',
        expire => 60 * 60 * 12,
        count  => 60,
    },
    {
        type   => 'day',
        expire => 60 * 60 * 12,
        count  => 100,
    },
];

sub new {
    my $class = shift;
    my $args = ref $_[0] eq 'HASH' ? $_[0] : {@_};

    my $config = Kirakira::Config->new();

    return $class->SUPER::new({
        cache => Cache::Memcached::Fast->new({
            servers => [ $config->cache ],
        }),
        ip    => $ENV{'REMOTE_ADDR'},
        %$args,
    });
}

sub get_cache_key {
    my $self = shift;
    my $type = shift;

    return "kirakira:throttle:$self->{ip}:$type";
}

sub call {
    my $self = shift;

    for my $pattern ( @$THROTTLE ){
        my $cache_key = $self->get_cache_key($pattern->{type});
        my $count = $self->cache->get($cache_key);
        if($count){
            $self->cache->incr($cache_key, 1);
        } else {
            $self->cache->set($cache_key, 1, $pattern->{expire});
        }
    }
}

sub is_restricted {
    my $self = shift;

    for my $pattern ( @$THROTTLE ){
        my $cache_key = $self->get_cache_key($pattern->{type});

        my $count = $self->cache->get($cache_key);
        return 1 if $count && $count > $pattern->{count};
    }

    return 0;
}

1;
