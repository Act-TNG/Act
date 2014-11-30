use strict;
use warnings;
use Test::More;
use Act::ResultSet;

my $event = {
    details  => {
        abstract     => 'hooray',
        event_id     => 3,
        conf_id      => 'ya2008',
        datetime     => '2008-05-15 18:00:00',
        duration     => 120,
        event_id     => 3,
        room         => 'out',
        title        => 'Party',
        url_abstract => '',
    },
};

subtest 'Event default' => sub {
    my $act_rs = Act::ResultSet->new(
        type  => 'Event',
        items => [ { id => $event->{'event_id'}, %{ $event->{'details'} } } ],
    );

    isa_ok( $act_rs, 'Act::ResultSet' );
    can_ok( $act_rs, qw<total all next> );

    is( $act_rs->total, 1, 'total() says only one event' );
};

subtest 'ResultSet all()' => sub {
    my $act_rs = Act::ResultSet->new(
        type  => 'Event',
        items => [ { id => $event->{'event_id'}, %{ $event->{'details'} } } ],
    );

    my @events = $act_rs->all();
    is( scalar @events, 1, 'all() returned one event' );
};

subtest 'ResultSet next() iterator' => sub {
    my $act_rs = Act::ResultSet->new(
        type  => 'event',
        items => [ { id => $event->{'event_id'}, %{ $event->{'details'} } } ],
    );

    my $count = 0;
    while ( my $event = $act_rs->next ) {
        $count++;
        isa_ok( $event, 'Act::Entity::Event' );
        can_ok(
            $event,
            qw<event_id conf_id title abstract url_abstract room duration datetime>,
        );

        ok( $event->$_, "Required $_ has value" )
            for qw<event_id conf_id title>;
    }

    is( $count, 1, 'Only one event through iterator' );
};

done_testing();
