package Act::REST::api::ResourceRoot::Role::Edition

=head1 NAME

Act::REST::api::Role::Edition

the role that provides the attribute for a C<Act::REST::api::RootResource>.
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

