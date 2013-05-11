package Kirakira::DB;
use strict;
use warnings;

use DBI;
use SQL::Abstract;

use constant {
    DB_SOURCE => 'DBI:mysql:kirakira',
    USER      => 'kirakira',
    PASS      => '',
    TABLE     => 'kirakira_map',
};

sub insert {
    my ($class, $param) = @_;

    my($sql, @bind) = SQL::Abstract->new()->insert(TABLE, $param);

    my $db = $class->_db();
    my $sth = $db->prepare($sql);
    return $sth->execute(@bind);
};

sub select_word {
    my ($class, $param) = @_;

    my($sql, @bind) = SQL::Abstract->new()->select(TABLE, 'word', $param);

    my $db = $class->_db();
    my $sth = $db->prepare($sql);
    $sth->execute(@bind);

    my $row = $sth->fetchrow_hashref();
    return '' unless $row;
    return $row->{word};
};

sub _db {
    return DBI->connect(DB_SOURCE, USER, PASS) || die $DBI::errstr;
}

1;
