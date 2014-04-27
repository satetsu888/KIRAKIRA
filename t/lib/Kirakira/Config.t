use strict;
use warnings;

use lib 'lib';

use Test::More;

use DBI;

BEGIN {
    use_ok("Kirakira::Config");
}

subtest new => sub {
    my $config = Kirakira::Config->new();
    isa_ok($config, 'Kirakira::Config');
};

subtest dbi => sub {
    my $config = Kirakira::Config->new();
    ok(DBI->connect($config->dbi()));
};

done_testing;
