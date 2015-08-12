package ActNext::Object::DataStore::Talks;

use constant _OBJECT_ITEM       => "ActNext::Object::Item::Talk";
use constant _OBJECT_SET        => "ActNext::Object::Set::Talks";
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

extends 'ActNext::Object::DataStore';

use Class::Load 'load_class';

load_class(_OBJECT_ITEM);
load_class(_OBJECT_SET);


sub coming_up_for_event {
    my $self = shift;
    my $conf_id = shift;
    
    my $time = DateTime->now(time_zone => 'america/denver'); # XXX Bad!
    
    my $time_string_starts = $time->subtract(minutes => 15)
        ->strftime->('%Y-%m-%d %H:%M:%S');
    my $time_string_ending = $time->add(minutes => 90)
        ->strftime->('%Y-%m-%d %H:%M:%S');
        
    my $list = $self->storage_engine->resultset($self->_PRIMARY_RESULTSET)
        ->search_rs({
            conf_id => $conf_id,
            datetime => { '>=', => $time_string_starts},
            datetime => { '<=', => $time_string_ending},
        }) or return undef;
    
    # create the class set
    return $self->_OBJECT_SET->new( { _proxy_set => $list } );
};

sub new_from_primary_resultset_row {
  my $self = shift;
  my $prim = shift;
  return _OBJECT_ITEM->new($self->inflated_hash($prim));
}

1;

