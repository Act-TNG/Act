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

# Catalyst-style dispatching
# this will work with CPAN Dancer2, but just doesn't have nice syntax (yet!)
any '/:conf_id/**' => sub {
    my $conf_id = param('conf_id');
    request->{'path'} =~ s/^\/$conf_id//;
    set conf_id => $conf_id;
    pass;
};

1;
