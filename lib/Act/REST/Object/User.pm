package Act::REST::Object::User;

use Moo;

with 'Act::REST::api::Multilingual';
extends "Act::REST::Object";

has '_proxy' => (
  is            => 'ro',
);

has '_ID' => (
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

#
# For Act::REST::api::Multilingual
#

sub _lang_attributes { (
  'biography', 
) };

sub _smpl_attributes { (
  'login_name',
  'first_name',
  'nick',
) };


sub TO_JSON { return { %{ shift() } }; };

1;
