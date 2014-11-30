package Act::Web::API;
# ABSTRACT: Web API interface to the Act system

BEGIN { $ENV{'ACTHOME'} = '.' }

use Dancer2;
use Act::Schema;
use Class::Load 'load_class';

    #Act::Web::API::Talk
my @classes = qw<
    Act::Web::API::Event
    Act::Web::API::News
    Act::Web::API::Payment
    Act::Web::API::Track
    Act::Web::API::Auth
    Act::Web::API::OpenID
    Act::Web::API::CSV
    Act::Web::API::Wiki
    Act::Web::API::User
>;

set serializer => 'JSON';

hook before => sub {
    my $sid = '';
    var user => config->{'schema'}->resultset('User')->find(
        { session_id   => $sid },
        { result_class => 'DBIx::Class::ResultClass::HashRefInflator' },
    );
};

sub setup {
    my $class  = shift;
    my $schema = shift;

    set schema => $schema ||
                  Act::Schema->connect( config->{'dsn'} );

    # force all of the paths under this prefix
    prefix '/:conf_id' => sub {
        load_class($_) && $_->import for @classes;
    };
}

1;
