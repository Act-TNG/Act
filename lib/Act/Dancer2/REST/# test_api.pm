package Act::Dancer2::REST::test_api;

use Dancer2;
# use Dancer2::Plugin::DBIC;

use Act::Dancer2::Plugin::ResourceRoot;

get '/news/?'
    => sub {
   # $rqst = request;
        return "News!\n";
    };

1;
