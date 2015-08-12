package ActNext::Dancer2::Handler::ResourceRoot::Role::Event;

=head1 NAME

ActNext::Dancer2::Handler::Resource::Role::Event

the role that provides the attribute for a C<ActNext::Dancer2::RootResource>.
This role is intended to be consumed dynamicly at instantion time.

=cut

use Moo::Role;

has _community_event => (
    is                  => 'ro',
#   isa                 => 'ActNext::Schema::Result::Conference',
);


1;

