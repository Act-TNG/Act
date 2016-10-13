package Act::Entity::Talk;
# ABSTRACT: An Act Talk entity

use Moo;
use MooX::Types::MooseLike::Base qw<Bool Int Str InstanceOf>;
with 'Act::Role::Entity';

has [ qw<id user_id> ] => (
    is       => 'ro',
    isa      => Int,
    required => 1,
);

has conf_id => (
    is       => 'ro',
    isa      => Str,
    required => 1,
);

has title => (
    is       => 'ro',
    isa      => Str,
    required => 1,
);

has [ qw<abstract url_abstract url_talk> ] => (
    is  => 'ro',
    isa => Str,
);

has duration => (
    is  => 'ro',
    isa => Int,
);

has [ qw<lightning accepted confirmed> ] => (
    is       => 'ro',
    isa      => Bool,
    default  => sub {0},
    required => 1,
);

has [ qw<comment room> ] => (
    is  => 'ro',
    isa => Str,
);

has datetime => (
    is  => 'ro',
    isa => InstanceOf['DateTime'],
);

has track_id => (
    is  => 'ro',
    isa => Int,
);

has level => (
    is      => 'ro',
    isa     => Int,
    default => sub {1},
);

has lang => (
    is  => 'ro',
    isa => Str,
);

1;
