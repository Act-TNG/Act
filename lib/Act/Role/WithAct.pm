package Act::Role::WithAct;

use Moo::Role;

has act => (
    is       => 'ro',
    required => 1,
    weak_ref => 1,
);

1;
