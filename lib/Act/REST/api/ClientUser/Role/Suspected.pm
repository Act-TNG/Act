package Act::REST::api::ClientUser::Role::Suspected;

=head1 NAME

Act::REST::api::CLientUser::Role::Suspected

the role that provides the attribute for a C<Act::REST::api::ClientUser>.
This role is intended to be consumed dynamicly at instantion time.

The Suspected role will be applied for those that have provided invalid
authentication credentials that do not match the credentials with the Act
Authentication mechanisms.

Most likely, a ClientUser whit this role assigned will cause a
401 "Not Authorized" response header.

However, since the design of the role-based system for authentication and
authorization has abstracted the ClientUser, the authentication only has to
check what permissions a ClientUser does have (within the context of a event)
and apply roles accordingly. The 'returned' ClientUser object only tells what
roles the user does and what methods therefore can perform.

It is entirely up to the calling web-framework to decide what to do with a user
that can't provide the right credentials.

=cut

use Moo::Role;

# methods might get added specific for suspected users

1;

