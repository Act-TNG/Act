package Act::Web::API::Event;
# ABSTRACT: Events in the API

use Dancer2 appname => 'Act::Web::API';

my $schema = config->{'schema'};

# Act::Handler::Event::Show
get '/event/:event_id' => sub {
    my $conf_id  = param('conf_id');
    my $event_id = param('event_id');

    $event_id =~ /^[0-9]+$/ or pass;

    my $event = $schema->resultset('Event')->search(
        {
            event_id => $event_id,
            conf_id  => $conf_id,
        },
        { result_class => 'DBIx::Class::ResultClass::HashRefInflator' },
    )->single() or send_error( 'No such event', 404 );

    return $event;
};

# Act::Handler::Event::List
get '/events' => sub {
    my $conf_id = param('conf_id');
    my @events  = $schema->resultset('Event')->search(
        { conf_id      => $conf_id },
        { result_class => 'DBIx::Class::ResultClass::HashRefInflator' },
    )->all or send_error( 'Cannot find events', 404 );

    return { results => \@events };
};

# Act::Handler::Event::Edit
get '/editevent' => sub {

};

# Act::Handler::Event::Show
get '/newevent' => sub {

};

1;
