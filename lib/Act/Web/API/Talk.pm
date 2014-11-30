package Act::Web::API::Talk;
use Dancer2 appname => 'Act::Web::API';
use Act::Talk;
use Act::User;
use Act::Handler::Util ();

# Act::Handler::Talk::Favorites
get '/favtalks' => sub {
    my $conf_id = param('conf_id');
};

# Act::Handler::Talk::Proceedings
get '/proceedings' => sub {
    my $conf_id = param('conf_id');

};

# Act::Handler::Talk::Slides
get '/slides' => sub {
    my $conf_id = param('conf_id');

};

# Act::Handler::Talk::Schdule
get '/schedule' => sub {
    my $conf_id = param('conf_id');

};

# Act::Handler::Talk::Show
get '/talk' => sub {
    my $conf_id = param('conf_id');

};

use Act::Util;
# Act::Handler::Talk::List
get '/talks/:type/:stag' => sub {
    my $conf_id = param('conf_id');
    my $type    = param('type');
    my $stag    = param('stag');

    my ( $tag, $talks );
    if ( $type eq 'tag' && $stag ) {
        $tag = Act::Util::normalize($stag);
        my @talk_ids = Act::Tag->find_tagged(
            conf_id => $conf_id,
            type    => 'talk',
            tags    => [$tag],
        );

        $talk = [ map Act::Talk->new( talk_id => $_ ), @talk_ids ];
    }

    forward "/$conf_id/talks";
};

get '/talks' => sub {
    my $conf_id = param('conf_id');
    my $talks   = Act::Talk->get_talks(
        conf_id => $conf_id,
    );

    my $talks_total = @{$talks};
    $_->{'user'} = Act::User->new( user_id => $_->user_id ) for @{$talks};

    my $user = var('user');

    # sort talks
    $talks = _filter_talks($talks);

    # compute some global information
    my ( $accepted, $lightnings, $duration ) = ( 0, 0, 0 );
    $_->accepted && do {
        $accepted++;
        $_->lightning ? $lightnings++ : ( $duration += $_->duration);
    } for @$talks;

    # link the talks to their tracks (keeping the talks ordered)
    my $tracks = Act::Track->get_tracks( conf_id => $conf_id );

    # add the "empty track" for talks without a track
    if ( @{$tracks} ) {
        unshift @{$tracks}, my $t = Act::Track->new();
        @{$t}{qw( conf_id track_id title description )}
            = ( $conf_id, '', '', '' );
    }

    for my $track ( @{$tracks} ) {
        my $id = $track->track_id;
        $track->{talks} = [ grep { $_->track_id == $id } @{$talks} ];
    }

    # get tag cloud
    my $tagcloud = Act::Tag->get_cloud(
        conf_id => $conf_id,
        type   => 'talk',
        filter => [ map $_->talk_id, @{$talks} ],
    );

    return $talks;
};

post '/talks' => sub {
    my $conf_id = param('conf_id');
    my $user    = var('user');
    my $talks   = Act::Talk->get_talks(
        conf_id => $conf_id,
    );

    $talks = _filter_talks($talks);

    # accept / unaccept talks
    if ( $user && $user->is_talks_admin ) {
        foreach my $talk ( @{$talks} ) {
            if ( $talk->accepted && ! param( $talk->talk_id ) ) {
                $talk->update( accepted => 0 );
                $talk->{accepted} = undef;
            } elsif ( !$talk->accepted && param( $talk->talk_id ) ) {
                $talk->update( accepted => 1 );
                Act::Handler::Talk::Util::notify_accept($talk);
            }
        }
    }

    redirect "/$conf_id/talks";
};

# Act::Handler::Talk::ExportIcal
get '/timetable.ics' => sub {
    my $conf_id = param('conf_id');

};

# Act::Handler::Talk::Edit
get '/edittalk' => sub {
    my $conf_id = param('conf_id');

};

# Act::Handler::Talk::ExportCSV
get '/export_talks' => sub {
    my $conf_id = param('conf_id');

};

# Act::Handler::Talk::Import
get '/ical_import' => sub {
    my $conf_id = param('conf_id');

};

# Act::Handler::Talk::MySchedule
get '/myschedule' => sub {
    my $conf_id = param('conf_id');

};

# Act::Handler::Talk::ExportMyIcal
get '/myschedule.ics' => sub {
    my $conf_id = param('conf_id');

};

# Act::Handler::Talk::Edit
get '/newtalk' => sub {
    my $conf_id = param('conf_id');

};

sub _filter_talks {
    my $talks = shift;
    my $user  = var('user');
    $talks = [
        sort {
               $a->lightning <=> $b->lightning
            || lc $a->{'user'}->last_name  cmp lc $b->{'user'}->last_name
            || lc $a->{'user'}->first_name cmp lc $b->{'user'}->first_name
            || $a->talk_id <=> $b->talk_id
        } grep {
               config->{'talks_show_all'}
            || $_->accepted
            || (
                $user && (    $user->is_talks_admin
                           || $user->user_id == $_->user_id
                         )
               )
        } @{$talks}
    ];

1;
