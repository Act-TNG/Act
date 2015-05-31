package Act::REST::api::Handler::Role::Event::MainAdmin;

=head1 NAME

Act::REST::api::Handler::Role::Event::MainAdmin

The C<MainAdmin> role provides an interface for all Main Admin's, specifacally
assigning roles (or rights) to users to help organising a Community Event.

=cut

use Moo::Role;

# more methods will get added for which no authentication is required

sub lookup_rights {
    shift->api
        ->datastore('Events')
        ->lookup_for_event(@_)
};

1;

