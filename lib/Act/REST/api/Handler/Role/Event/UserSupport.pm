package Act::REST::api::Handler::Role::Event::UserSupport;

=head1 NAME

Act::REST::api::Handler::Role::Event::UserSupport

The C<UserSupport> role provides an interface for ...

=cut

use Moo::Role;

# more methods will get added for which no authentication is required

sub lookup_user {
    shift->api
        ->datastore('Users')
        ->lookup_for_event(@_)
};

1;

