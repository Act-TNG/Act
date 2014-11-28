package Act::Role::Entity;
# ABSTRACT: A role defining entities

use Moo::Role;
use MooX::Types::MooseLike::Base qw<HashRef>;

has config => (
    is      => 'ro',
    isa     => HashRef,
    default => sub { +{} },
);

1;
