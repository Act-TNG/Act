package Act::Next::DataStore::Talks;

use constant _RESOURCE_OBJECT   => "Act::Next::Object::Talk";
use constant _RESOURCE_SET      => "Act::Next::Set::Talks";
use constant _PRIMARY_RESULTSET => "Talk";
use constant _PRIMARY_INDEX     => "talk_id";
use constant _ATTRIBUTES        => {
    title               => 'title',
    abstract            => 'abstract',
    duration            => 'duration',
    duration            => 'duration',
    speaker_id          => 'user_id',
    room                => 'room',
    start_time          => 'datetime',
    target_level        => 'level',
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

