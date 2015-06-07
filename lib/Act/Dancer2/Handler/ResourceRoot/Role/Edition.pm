package Act::Dancer2::Handler::ResourceRoot::Role::Edition

=head1 NAME

Act::Dancer2::Handler::Resource::Role::Edition

the role that provides the attribute for a C<Act::Dancer2::RootResource>.
This role is intended to be consumed dynamicly at instantion time.

=cut

use Moo::Role;

has edition => {
  is                   => 'ro',
  isa                  => 'Str',
};

sub syndicate {
# return $_[0]->_communtiy_event->syndicate;
};

1;

