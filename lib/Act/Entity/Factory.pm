package Act::Entity::Factory;
# ABSTRACT: A factory to find entities

use Moo;
with 'Act::Role::Entity';

sub search {
    my ( $self, $entity, $query ) = @_;
}

1;
