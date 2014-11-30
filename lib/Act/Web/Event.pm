package Act::Web::Event;
use Dancer2 appname => 'Act::Web';
set auto_page => 1;

use Act::Form;
use Act::Abstract;
use Act::Template::HTML;
use DateTime::Format::Pg;

my $form = Act::Form->new(
  required => [qw( title abstract )],
  optional => [qw( url_abstract duration date time room delete )],
  constraints => {
     duration     => 'numeric',
     url_abstract => 'url',
     date         => 'date',
     time         => 'time',
     room         => sub { exists config->{'rooms'}{$_[0]} or $_[0] =~ /^(?:out|venue|sidetrack)$/},
  }
);

my $act = Act::API->new( port => config->{'api_port'} );

# Act::Handler::Event::Show
get '/event/:event_id' => sub {
    my $event = $act->event( param('event_id') );
    my $tags  = $act->tags( { event_id => $event->event_id } );

    my $template = Act::Template::HTML->new();
    $template->variables(
        event => $event,
        chunked_abstract => Act::Abstract::chunked( $event->abstract ),
    );

    return $template->process('events/show');
};

# Act::Handler::Event::List
get '/editevent' => sub {

};

# Act::Handler::Event::Show
get '/newevent' => sub {

};

1;
