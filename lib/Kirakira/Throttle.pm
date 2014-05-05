package Kirakira::Throttle;
use strict;
use warnings;

use parent 'Class::Accessor::Fast';
__PACKAGE__->mk_accessors(qw/ cache /);

use Cache::Memcached::Fast;

use Kirakira::Config;

sub new {
    my $class = shift;

    my $args = ref $_[0] eq 'HASH' ? $_[0] : {@_};

    my $config = Kirakira::Config->new();

    return $class->SUPER::new({
        cache => Cache::Memcached::Fast->new({
            servers => [ $config->cache ],
        }),
        %$args,
    });
}

1;
