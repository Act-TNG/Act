package Act::Entity::User;

use Moo;

with 'Act::Role::Entity',
     'Act::Role::EntityWithLegacy';

sub _build_legacy {
    my ($self) = @_;
    require Act::Legacy::User;
    return Act::Legacy::User->new( act => $self->act,
        %{ $self->_legacy_data } );
}

1;
