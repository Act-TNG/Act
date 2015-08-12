package Act::Dancer2::Handler::ResourceRoot::Role::Resource;

=head1 NAME

Act::Dancer2::Handler::ResourceRoot::Role::Resource

the role that provides the attribute for a C<Act::Dancer2::RootResource>.
This role is intended to be consumed dynamicly at instantion time.

Resources are those that represent root objects or
collections i.e. /talks or /users. In RESTful api's we prefer to use
relations that represent some form of hiearchy.

=cut

use Moo::Role;

1;
