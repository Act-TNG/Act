package Act::Dancer2::REST::Role::Event::UserSupport;

=head1 NAME

Act::Dancer2::REST::Role::Event::UserSupport

The C<UserSupport> role provides an interface for ...

=cut

use Moo::Role;

# more methods will get added for which no authentication is required

sub lookup_user {
    shift->api
        ->resource('Users')
        ->lookup_for_event(@_)
};

1;

