package Kirakira::DB;
use strict;
use warnings;

use DBI;
use SQL::Abstract;

use Kirakira::Config;

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

    my($sql, @bind) = SQL::Abstract->new()->select(
        TABLE,
        'word',
        +{
            hash => +{ -like => "$param->{hash}%" }
        }
    );

    my $db = $class->_db();
    my $sth = $db->prepare($sql);
    $sth->execute(@bind);

    my $row = $sth->fetchrow_hashref();
    return '' unless $row;
    return $row->{word};
};

sub delete_create_at_until {
    my ($class, $param) = @_;
    my($sql, @bind) = SQL::Abstract->new()->delete(
        TABLE,
        {
            create_at => {'<', $param->{until}},
        }
    );

    my $db = $class->_db();
    warn $sql;
    my $sth = $db->prepare($sql);
    return $sth->execute(@bind);

}

sub _db {
    my $config = Kirakira::Config->new;
    return DBI->connect($config->dbi()) || die $DBI::errstr;
}

1;
