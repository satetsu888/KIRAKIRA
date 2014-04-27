package Kirakira::Config;
use strict;
use warnings;

use parent 'Class::Accessor::Fast';

use YAML::XS;
use Data::Dumper;

use constant {
    CONFIG_FILE_PATH => 'config.yaml',

    DEFAULT_CONFIGS => {
        DB_TYPE   => 'mysql',
        DB_HOST   => 'localhost',
        DB_PORT   => '3306',
        DB_USER   => 'kirakira',
        DB_PASS   => '',
        DB_NAME   => 'kirakira',
        DB_TABLE  => 'kirakira_map',
    },
};

my @configs = qw/
    db_type
    db_host
    db_user
    db_pass
    db_name
    db_table
/;

__PACKAGE__->mk_accessors( @configs );

sub new {
    my $class = shift;

    my $self = $class->SUPER::new;
    $self->load;
    return $self;
}

sub load {
    my $self = shift;

    my $hash;
    eval {
        $hash = YAML::XS::LoadFile(CONFIG_FILE_PATH());
    };
    if($@){
        warn $@;
    }

    for(@configs){
        $self->{$_} =
            $hash->{$_} || DEFAULT_CONFIGS()->{uc $_};
    }
}

sub dbi {
    my $self = shift;

    my $source = "DBI:$self->{db_type}:$self->{db_name}:$self->{db_host}:$self->{db_pass}";

    return ($source, $self->{db_user}, $self->{db_pass});
}


1;
