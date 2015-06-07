package Act::Next::Object::Talk;

use Moo;

with 'Act::Next::Role::Multilingual';
extends "Act::Next::Object";

has '_proxy' => (
  is            => 'ro',
);

has '_ID' => (
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

has 'speaker' => (
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
