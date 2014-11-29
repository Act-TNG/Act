package Act::Role::WithLegacy;

use Moo::Role;

requires '_build_legacy';

has legacy => (
    is => 'lazy',
);

has _legacy_data (
    is      => 'ro',
    default => {},
);

1;
