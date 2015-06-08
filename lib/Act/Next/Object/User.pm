package Act::Next::Object::User;

use Moo;

use constant _RESOURCE_DATASTORE => 'Act::Next::DataStore::Users';

with 'Act::Next::Role::Multilingual';
extends "Act::Next::Object";

has '_proxy' => (
  is            => 'ro',
);

has '_INDEX' => (
  is            => 'ro',
);

has 'login_name' => (
  is            => 'ro',
);

has 'first_name' => (
  is            => 'ro',
);

has 'nick' => (
  is            => 'ro'
);

has 'biography' => (
  is            => 'ro'
);

# sub TO_JSON { return { %{ shift() } }; };

1;
