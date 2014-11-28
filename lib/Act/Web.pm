package Act::Web;
use Dancer2;
use Act::API;
use Act::Schema;
use Act::Web::Talk;

our $VERSION = '0.001';

my $act = Act::API->new( %{ config() } );
set act => $act;

# create the schema and store in the config
hook before => sub {
    # create a user
    if ( my $user = request->user ) {
        var user => $act->find_user({ name => $user });
    }
};

get '/' => sub {
    template 'index';
};

1;

