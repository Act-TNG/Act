use strict;
use warnings;

binmode STDOUT, ":utf8";

use FindBin;
use lib "$FindBin::Bin/../lib";

use Act::Config;
use Act::Schema;
use YAML;

my $ActSchema = Act::Schema->connect(
  $Config->database_dsn,
  $Config->database_user,
  $Config->database_passwd,
  undef
);

my %cols = map +($_ => 1),$ActSchema->source('Conference')->columns;

my $file_import = $ARGV[0];
my $data_import = YAML::LoadFile($file_import);

my @data_sane = map {
  my $r = $_;
  +{
    map +($_ => $r->{$_}), grep $cols{$_}, keys %$r
  }
} @$data_import;

$ActSchema->deploy( { sources => [ 'Conference' ], add_drop_table => 1 } );

my $conference_list = $ActSchema
  ->resultset('Conference')
  ->populate(\@data_sane);

use DDP; p $conference_list;

__END__
