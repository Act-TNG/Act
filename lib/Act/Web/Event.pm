package Act::Web::Event;
use Dancer2 appname => 'Act::Web';
set auto_page => 1;

use Act::Form;

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

get '/event/:event_id' => sub {
    my $event = $act->event( param('event_id') );
    my $tags  = $act->tags( { event_id => $event->event_id } );

    my $template = Act::Template->new();
    $template->variables();
    return $template->process('events/show');
};


1;
