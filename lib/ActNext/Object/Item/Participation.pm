package Act::Next::Object::Participation;

use Moo;

use constant _RESOURCE_DATASTORE => 'Act::Next::DataStore::Participation';

extends "Act::Next::Object";

has '_proxy' => (
  is            => 'ro',
);

has 'attendend_id' => (
  is            => 'ro',
);

has 'event_id' => (
  is            => 'ro',
);

# sub TO_JSON { return { %{ shift() } }; };

1;
