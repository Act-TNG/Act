package Act::Next::DataStore::Participations;

use constant _RESOURCE_OBJECT   => "Act::Next::Object::Participation";
use constant _RESOURCE_SET      => "Act::Next::Set::Participations";
use constant _PRIMARY_RESULTSET => "Participation";
use constant _PRIMARY_INDEX     => undef;
use constant _ATTRIBUTES        => {
    event_id            => 'conf_id',
    attendend_id        => 'user_id',
};


use Moo;

extends 'Act::Next::DataStore';

use Class::Load 'load_class';

load_class(_RESOURCE_OBJECT);
load_class(_RESOURCE_SET);




sub new_from_primary_resultset_row {
  my $self = shift;
  my $prim = shift;
  return _RESOURCE_OBJECT->new($self->inflated_hash($prim));
}

1;

