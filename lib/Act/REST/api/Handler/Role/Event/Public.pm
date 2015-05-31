package Act::REST::api::Handler::Role::Event::Public;

=head1 NAME

Act::REST::api::Handler::Role::Event::Public

The C<Public> role provides an interface for all ClientUsers

=cut

use Moo::Role;

# more methods will get added for which no authentication is required

sub lookup_syndicate {
    shift->api
        ->datastore('Syndicates')
        ->lookup(@_)
};

sub lookup_edition {
    shift->api
        ->datastore('Editions')
        ->lookup(@_)
};

sub lookup_user {
    shift->api
        ->datastore('Users')
        ->lookup(@_)
};

sub lookup_talk {
    shift->api
        ->datastore('Talks')
        ->lookup(@_)
};

1;

