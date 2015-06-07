use lib '../lib';

use Act::Dancer2::REST::handler;

use Plack::Builder;

builder {
    enable 'Plack::Middleware::Act::ResourceRoot';
#   enable 'Plack::Middleware::Act::ResourceRoot::Syndicate';
#   enable 'Plack::Middleware::Act::ResourceRoot::Edition';
    
    Act::Dancer2::REST::handler->to_app;
};

__END__