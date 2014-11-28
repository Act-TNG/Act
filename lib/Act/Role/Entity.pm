package Act::Role::Entity;
# ABSTRACT: A role defining entities

use Moo::Role;
use MooX::Types::MooseLike::Base qw<HashRef InstanceOf>;

has config => (
    is      => 'ro',
    isa     => HashRef,
    default => sub { +{} },
);

has act => (
    is       => 'ro',
    isa      => InstanceOf['Act::API'],
    weak_ref => 1,
);

has schema => (
    is      => 'ro',
    isa     => InstanceOf['Act::Schema'],
    lazy    => 1,
    builder => 1,
);

sub _build_schema { shift->act->schema }

1;
