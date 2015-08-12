package ActNext::Object::DataStore::Participations;

use constant _OBJECT_ITEM       => "ActNext::Object::Item::Participation";
use constant _OBJECT_SET        => "ActNext::Object::Set::Participations";
use constant _PRIMARY_RESULTSET => "Participation";
use constant _PRIMARY_INDEX     => undef;
use constant _ATTRIBUTES        => {
    event_id            => 'conf_id',
    attendend_id        => 'user_id',
};


use Moo;

extends 'ActNext::Object::DataStore';

use Class::Load 'load_class';

load_class(_OBJECT_ITEM);
load_class(_OBJECT_SET);




sub new_from_primary_resultset_row {
  my $self = shift;
  my $prim = shift;
  return _OBJECT_ITEM->new($self->inflated_hash($prim));
}

1;

