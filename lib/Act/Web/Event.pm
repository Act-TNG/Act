package Act::Web::Event;
use Dancer2 appname => 'Act::Web';
set auto_page => 1;

use Act::Form;
use Act::Abstract;
use Act::Template::HTML;
use DateTime::Format::Pg;

my $act = Act::API->new( port => config->{'api_port'} );

# Act::Handler::Event::Show
get '/event/:event_id' => sub {
    my $event_id = param('event_id');
    $event_id =~ /^[0-9]$/ or pass;

    my $event = $act->event({ id => $event_id });
    $event->total > 0 or pass;

    my $template = Act::Template::HTML->new();

    $template->variables(
        %{$event},
        chunked_abstract => Act::Abstract::chunked( $event->abstract ),
    );

    return $template->process('events/show');
};

# Act::Handler::Event::List
get '/editevent' => sub {
    var('user')->is_talks_admin or pass;

    my $form = Act::Form->new(
      required    => [qw( title abstract )],
      optional    => [qw( url_abstract duration date time room delete )],
      constraints => {
         duration     => 'numeric',
         url_abstract => 'url',
         date         => 'date',
         time         => 'time',
         #room         => sub { exists $Config->{'rooms'}{$_[0]} or $_[0] =~ /^(?:out|venue|sidetrack)$/},
        room          => sub { die 'Not implemented yet' },
      }
    );

    my $template = Act::Template::HTML->new();
    my $fields;

    my $sdate = $act->talks_start_date;
    my $edate = $act->talks_end_date;

    my @dates = ($sdate->clone->truncate(to => 'day' ));
    push @dates, $_
        while (($_ = $dates[-1]->clone->add( days => 1 ) ) < $edate );


    $template->variables(
        events => [
            sort { $a->datetime cmp $b->datetime } @{ $events->all }
        ]
    );

    $template->process('event/list');
};

# alias to Act::Handler::Event::Edit
get '/newevent' => sub { forward '/editevent' };

# Act::Handler::Event::Edit
get '/editevent' => sub {

};

1;
