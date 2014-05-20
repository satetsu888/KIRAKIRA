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

subtest is_restricted => sub {
    my $throttle = Kirakira::Throttle->new();
    my $dummy_ip = 'dummy_for_is_restricted_test'. int rand 0xFFFF;
    $throttle->ip($dummy_ip);

    $throttle->cache->set(
        "kirakira:throttle:$dummy_ip:short",
        10,
    );

    is($throttle->is_restricted(), 1);
};

subtest call => sub {
    my $throttle = Kirakira::Throttle->new();
    my $dummy_ip = 'dummy_for_call_test'. int rand 0xFFFF;
    $throttle->ip($dummy_ip);

    $throttle->call();
    is($throttle->is_restricted(), 0);
    $throttle->call();
    is($throttle->is_restricted(), 0);
    $throttle->call();
    is($throttle->is_restricted(), 0);
    $throttle->call();
    is($throttle->is_restricted(), 0);
    $throttle->call();
    is($throttle->is_restricted(), 0);
    $throttle->call();
    is($throttle->is_restricted(), 1, 'get restricted call 6th time in short duration');

};

done_testing;

