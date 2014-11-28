package Act::Role::Entity::HasConference;
# ABSTRACT: Entity objects that need a conference

use Moo;
use MooX::Types::MooseLike::Base qw<InstanceOf>;

has conference => (
    is      => 'ro',
    isa     => InstanceOf['Act::Entity::Conference'],
    lazy    => 1,
    builder => '_build_conference',
);

sub _build_conference {
    my $self   = shift;
    my $config = $self->config;

    return $self->find_conference({
        id => $self->config->{'conf_id'},
    });
}

1;
