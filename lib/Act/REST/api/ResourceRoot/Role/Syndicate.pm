package Act::REST::api::ResourceRoot::Role::Syndicate;

=head1 NAME

Act::REST::api::Role::Syndicate

the role that provides the attribute for a C<Act::REST::api::RootResource>.
This role is intended to be consumed dynamicly at instantion time.

Syndicate RootResources establish relations towards C<Edition>s. RootResources
with these roles are also dealing agregated resources like News.

=cut

use Moo::Role;

has syndicate => {
  is                   => 'ro',
  isa                  => 'Str',
};

sub editions {
};

1;
