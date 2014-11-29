package Act::Role::Entity;

use Moo::Role;

with 'Act::Role::WithAct';

sub save {
    my ($self) = @_;
    $self->act->save_entity($self);
}

1;
