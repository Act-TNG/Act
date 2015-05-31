package Act::REST::api::ClientUser::Role::Authenticated;

=head1 NAME

Act::REST::api::ClientUser::Role::Authenticated

the role that provides the attribute for a C<Act::REST::api::ClientUser>.
This role is intended to be consumed dynamicly at instantion time.

The Authenticated role is the bare minimum for those that have provided valid
authentication credentials that match the credentials with the Act
Authentication mechanisms.

=cut

use Moo::Role;

# methods might get added for which no authentication is required

1;

