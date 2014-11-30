use strict;
use warnings;
use Test::More;
use Plack::Test;
use HTTP::Request::Common;
use JSON;
use Try::Tiny;

use Dancer2;
use Act::Schema;
use Act::Web::API;

Act::Web::API->setup(
    Act::Schema->connect('dbi:SQLite:dbname=t/corpus/act.sqlite')
);

my $schema = Act::Web::API->config->{'schema'};
my $test   = Plack::Test->create( Act::Web::API->to_app );

my $conf_id = 'ya2008';
my $event   = {
    id       => 3,
    details  => {
        abstract     => 'hooray',
        conf_id      => 'ya2008',
        datetime     => '2008-05-15 18:00:00',
        duration     => 120,
        event_id     => 3,
        room         => 'out',
        title        => 'Party',
        url_abstract => '',
    },
};

subtest 'Show single event' => sub {
    my $res = $test->request( GET "/$conf_id/event/$event->{'id'}" );
    ok( $res->is_success, 'Successful result' );

    my $data = try { decode_json $res->content };
    isa_ok( $data, 'HASH', 'Got data back' );
    is_deeply( $data, $event->{'details'}, 'Correct event' );
};

subtest 'List all events' => sub {
    my $res = $test->request( GET "/$conf_id/events" );
    ok( $res->is_success, 'Successful result' );

    my $data = try { decode_json $res->content };
    isa_ok( $data, 'HASH', 'Got event details' );
    is_deeply(
        $data,
        { results => [ $event->{'details'} ] },
        'Correct events',
    );
};

done_testing();
