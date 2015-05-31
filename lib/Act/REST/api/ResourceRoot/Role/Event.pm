package Act::REST::api::ResourceRoot::Role::Event;

=head1 NAME

Act::REST::api::Role::Event

the role that provides the attribute for a C<Act::REST::api::RootResource>.
This role is intended to be consumed dynamicly at instantion time.

=cut

use Moo::Role;

has _community_event => (
    is                  => 'ro',
#   isa                 => 'Act::Schema::Result::Conference',
);


1;

