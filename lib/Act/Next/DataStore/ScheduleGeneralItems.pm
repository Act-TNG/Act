package Act::Next::DataStore::ScheduleGeneralItems;

use constant _RESOURCE_OBJECT   => "Act::Next::Object::ScheduleGeneralItem";
use constant _RESOURCE_SET      => "Act::Next::Set::ScheduleGeneralItems";
use constant _PRIMARY_RESULTSET => "Event";
use constant _PRIMARY_INDEX     => "event_id";
use constant _ATTRIBUTES        => {
    title               => 'title',
    abstract            => 'abstract',
    duration            => 'duration',
#   speaker_id          => 'user_id', general items don't have one
    room                => 'room',
    start_time          => 'datetime',
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
};

sub coming_up_for_event {
    use DDP; p @_;
    my $self = shift;
    my $prms = shift;
 
    my $time_starts = DateTime->now(time_zone => 'America/Denver');
    $time_starts->subtract(minutes => 420);
    my $time_starts_string = $time_starts->strftime('%Y-%m-%d %H:%M:%S');

    my $time_ending = DateTime->now(time_zone => 'America/Denver');
    $time_ending->add(minutes => 90);
    my $time_ending_string = $time_ending->strftime('%Y-%m-%d %H:%M:%S');

    my $list = $self->storage_engine->resultset($self->_PRIMARY_RESULTSET)
        ->search_rs({
	    -and => [
                conf_id  => $prms->{conf_id} ,
                datetime => { '>=' => $time_starts_string },
                datetime => { '<=' => $time_ending_string },
            ]
        }) or return undef;
    
    # create the class set
    return $self->_RESOURCE_SET->new( { _proxy_set => $list } );
};

1;

