package Act::REST::api::ClientUser::Role::Anonymous;

=head1 NAME

Act::REST::api::ClientUser::Role::Anonymous

the role that provides the attributes and roles for a
C<Act::REST::api::ClientUserr>.
This role is intended to be consumed dynamicly at instantion time.

An api::ClientUser with only the anonymous role will be very limited in what
they can handle. Certainly not adding stuff to the database and defenitly not
deleting things.

=cut

use Moo::Role;

# methods might get added for which no authentication is required

1;

