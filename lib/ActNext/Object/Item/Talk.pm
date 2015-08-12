package Act::Next::Object::Talk;

use Moo;

use constant _RESOURCE_DATASTORE => 'Act::Next::DataStore::Talks';

with 'Act::Next::Role::Multilingual';
extends "Act::Next::Object";

has '_proxy' => (
  is            => 'ro',
);

has '_INDEX' => (
  is            => 'ro',
);

has 'title' => (
  is            => 'ro',
);

has 'abstract' => (
  is            => 'ro',
);

has 'duration' => (
  is            => 'ro'
);

has 'speaker_id' => (
  is            => 'ro'
);

has 'room' => (
  is            => 'ro'
);

has 'start_time' => (
  is            => 'ro'
);

has 'target_level' => (
  is            => 'ro'
);

# sub TO_JSON { return { %{ shift() } }; };

1;
