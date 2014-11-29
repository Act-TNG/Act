package Act::Web::Event;
use Dancer2 appname => 'Act::Web';

# originally: list
get '/events' => sub {
    # we require act to even match
    my $conf_id = param('conf_id') or pass;

    ...
    $template->process('event/list');
};

# or: /event/:id
get '/event' => sub {
    # we require act to even match
    my $conf_id = param('conf_id') or pass;
    my $talk_id = param('talk_id') or pass;

    $template->process('event/show');
};

# aliasing
get '/newevent' => sub { forward '/editevent' };

# or: /event/edit
get '/editevent' => sub {
    # we require act to even match
    my $conf_id = param('conf_id') or pass;
    my $talk_id = param('talk_id') or pass;

    my $return_url = param('return_url') ||
        request->referer if request->referer =~ m{/schedule};

    $template->process('event/add');
};

post '/editevent' => sub {
    # we require act to even match
    my $conf_id = param('conf_id') or pass;
    my $talk_id = param('talk_id') or pass;

    my $return_url = param('return_url') ||
        request->referer if request->referer =~ m{/schedule};

    redirect "/$conf_id/editevent?talk_id=$talk_id";
};

1;

