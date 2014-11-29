package Act::Role::EntityWithLegacy;

use Moo::Role;

requires '_build_legacy';

has legacy => (
    is => 'lazy',
);

has _legacy_data => (
    is      => 'ro',
    default => sub { {} },
);

1;
