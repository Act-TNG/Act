package ActNext::Object::Item::User;

use Moo;

use constant _RESOURCE_DATASTORE => 'ActNext::Object::DataStore::Users';

with 'ActNext::Object::Role::Multilingual';
extends "ActNext::Object::Item";

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
