package Act::Dancer2::REST::handler;

use Dancer2;
#use Carp::Always;
use Act::Dancer2::Plugin::HTTP::Auth;

get '/news/?'
    => sub {
        return "More News!\n";
};

get '/secret/?'
    => http_require_authentication sub {
        return "Pssst this entrusted News!\n";
};

get '/single_role/?'
    => http_require_task 'lookup_user' => sub {
        return "You do a 'Public role!\n";
};

get '/all_role/?'
    => http_require_task_all [
        'lookup_user',
        'lookup_rights'
    ] => sub {
        return "You do a 'Public role!\n";
};

get '/:synd/:edtn/user/:id'
    => http_require_task 'lookup_user' => sub {
    my $user = http_auth_handler->lookup_user( params->{id} );
    return $user->_to_json( );
};

get '/:synd/:edtn/participants/?'
    => http_require_task 'export_participation' => sub {
    my $user = http_auth_handler->export_participation( params->{id} );
    return $user->_to_json( );
};



get '/users/:id'
    => http_require_task 'lookup_user' => sub {
    my $user = http_auth_handler->lookup_user( params->{id} );
    unless ($user) { status 404; return };
use DDP; p $user;
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
    my $list = http_auth_handler->export_user_for_talk( $talk );
    my @list;
    while (my $user = $list->next) {
        push @list, {
            href    => "/users/$user->{_ID}",
            label   => $user->{first_name},
        }
    }
    return to_json (\@list);
    
    
    return $talk->_to_json( );
};


get '/users/?'
    => http_require_task 'export_user' => sub {
    my $list = http_auth_handler->export_user( params->{id} );
    my $count = $list->count;
    my @list;
    while (my $user = $list->next) {
        push @list, {
            href    => "/users/$user->{_ID}",
            label   => $user->{first_name},
        }
    }
    return to_json (\@list);
};

get '/:synd/:edtn/talks/?' => sub { };
1;
