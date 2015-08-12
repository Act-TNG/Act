package ActNext::Dancer2::REST::test_api;
print "HELP\n";
use Dancer2;
use ActNext::Dancer2::Plugin::HTTP::Auth::ActNext;

get '/users/?'
    => http_require_task 'export_user' => sub {
    my $list = http_auth_handler->export_user( params->{id} );
    my $count = $list->count;
    my @list;
    while (my $user = $list->next) {
        push @list, {
            href    => "/users/$user->{_INDEX}",
            label   => $user->{first_name},
        }
    }
    return to_json (\@list);
};

get '/users/:id'
    => http_require_task 'lookup_user' => sub {
    my $user = http_auth_handler->lookup_user( params->{id} );
    unless ($user) { status 404; return };
    return $user->_to_json( );
};

get '/talks/:id'
    => http_require_task 'lookup_talk' => sub {
    my $talk = http_auth_handler->lookup_talk( params->{id} );
    unless ($talk) { status 404; return };
    return $talk->_to_json( );
};

get '/talks/:id/attendees'
    => http_require_task_all [
        'lookup_talk',
        'export_user_for_talk'
    ] => sub {
    my $talk = http_auth_handler->lookup_talk( params->{id} );
    unless ($talk) { status 404; return };
    my $list = http_auth_handler->export_users_for_talk( $talk );
    my @list;
    while (my $user = $list->next) {
        push @list, {
            href    => "/users/$user->{_INDEX}",
            label   => $user->{first_name},
        }
    }
    return to_json (\@list);
    
    
    return $talk->_to_json( );
};

get '/:synd/:edtn/attendees/?'
    => http_require_task 'export_attendees_for_event' => sub {
    my $list = http_auth_handler->export_attendees_for_event( );
    my @list;
    while (my $user = $list->next) {
        push @list, {
            href    => "/users/$user->{_INDEX}",
            label   => $user->{first_name},
        }
    }
    return to_json (\@list);
    return;
};

get '/:synd/:edtn/talks/?'
    => http_require_task 'export_talks' => sub {
    my $list = http_auth_handler->export_talks( params->{id} );
    my @list;
    while (my $talk = $list->next) {
        push @list, {
            href    => "/talks/$talk->{_INDEX}",
            label   => $talk->{title},
        } # if $talk->{_proxy}->{accepted};
    }
    return to_json (\@list);

};
1;
