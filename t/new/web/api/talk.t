use strict;
use warnings;
use Test::More;
use Plack::Test;
use HTTP::Request::Common;

use Dancer2;
use Act::Schema;
use Act::Web::API;

Act::Web::API->setup(
    Act::Schema->connect('dbi:SQLite:dbname=:memory')
);

my $schema = Act::Web::API->config->{'schema'};
my $test   = Plack::Test->create( Act::Web::API->to_app );

subtest 'List talks' => sub {
    my $res = $test->request( GET '/myconf/favtalks' );
};


done_testing();
