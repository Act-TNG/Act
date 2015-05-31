package Act::Dancer2::REST::handler;

use Dancer2;

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
    => http_require_task_all [
        'lookup_user',
        'lookup_rights'
    ] => sub {
        return "You do a 'Public role!\n";
    };

1;
