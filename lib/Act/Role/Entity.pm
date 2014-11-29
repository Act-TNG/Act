package Act::Role::Entity;

has act => (
    is       => 'ro',
    required => 1,
    weak_ref => 1,
);

sub save {
    my ($self) = @_;
    $self->act->save_entity($self);
}

1;
