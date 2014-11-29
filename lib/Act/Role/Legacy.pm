package Act::Role::Legacy;

use Moo::Role;

has act => (
    is       => 'ro',
    required => 1,
    weak_ref => 1,
);

sub BUILD {
    my ($self) = @_;
    die "Not in a legacy context"
        unless $self->act->does('Act::Role::Storage::DBIC');
}

1;
