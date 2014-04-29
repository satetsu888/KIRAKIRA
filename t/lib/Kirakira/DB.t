use strict;
use warnings;
use lib 'lib';

use Test::More;

BEGIN {
    use_ok("Kirakira::DB");
}

subtest delete_create_at_until => sub {
    my $result = Kirakira::DB->delete_create_at_until(
        {until => "2014/01/01"}
    );

    ok($result);
};

done_testing;
