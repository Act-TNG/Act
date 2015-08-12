package ActNext::Object::Item::Participation;

use Moo;

use constant _RESOURCE_DATASTORE => 'ActNext::Object::DataStore::Participation';

extends "ActNext::Object::Item";

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
