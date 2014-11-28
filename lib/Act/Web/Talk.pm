package Act::Web::Talk;
use Dancer2 appname => 'Act::Web';

# /fpw2013/**
prefix '/:conf_id' => sub {
    # Act::Handler::Talk::Show
    post qr{^/talk/(\d+)$} => sub {
        my $talk_id = param('id');
        my $conf_id = param('conf_id'}:
        my $act     = var('act');

        my $talk = $act->find_talk({
            conf_id => $conf_id,
            talk_id => $talk_id,
        });

        my $new_tags = param('tags');
        my $tags     = $talk->tags;
        $act->add_tags_to_talk({
            talk     => $talk,
            conf_id  => $conf_id,
            new_tags => $new_tags,
        });

        redirect "/$conf_id/talk/$talk->id";
    };

    get qr{^/talk/(\d+)$} => sub {
        my $talk_id = param('id');
        my $conf_id = param('conf_id');
        my $act     = var('act');

        my $talk = $act->find_talk({
            conf_id => $conf_id,
            talk_id => $talk_id,
        });

        # XXX this is actually speaker, not "user"
        # XXX should we really return a 404? better redirect + flash msg
        $talk->displayable && $talk->presenters
            or send_error(404);

        my $template = Act::Template::HTML->new();
        $template->variables(
            chunked_abstract => Act::Abstract::chunked( $talk->abstract ),
            talk => $talk,
            user => var('user'),

            # 'attendees' and 'tags' are derived from 'talk' object
        );

        # talk level?!

        return $template->process('talk/show');
    };

    # Act::Handler::Talk::List
    get '/talks' => sub {
    };
};

1;

