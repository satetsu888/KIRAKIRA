use strict;
use warnings;
use lib 'lib';

use Test::More;

BEGIN {
    use_ok('Kirakira::Throttle');
}

subtest basic => sub {
    my $throttle = Kirakira::Throttle->new();
    isa_ok($throttle->cache, 'Cache::Memcached::Fast');
};

done_testing;

