package Act::Next::DataStore::Talks;

use constant RESOURCE_OBJECT    => "Act::Next::Object::Talk";
use constant RESOURCE_SET       => "Act::Next::Set::Talks";
use constant PRIMARY_RESULTSET  => "Talk";

use Moo;

extends 'Act::Next::DataStore';

use Class::Load 'load_class';

load_class(RESOURCE_OBJECT);
load_class(RESOURCE_SET);

# our $prim_columns = {
#     _ID                 => 'user_id',
#     login_name          => 'login',
#     nick                => 'nick_name',
#     first_name          => 'first_name',
# };

sub attributes_simple { (
    'title',
    'abstract',
    'duration',
    'speaker',
    'room',
    'start_time',
    'target_level',
) }

sub attributes_multilingual { (
) };


sub ResourceSetExport {
    return ( qw |first_name nick_name| )
};

sub lookup {
  my $clss = shift;
  my @keys = @_;
  
  # find the primitive for this class
  my $prim = $clss->storage_engine->resultset(PRIMARY_RESULTSET)
    ->find(@keys) or return undef;
  
  # create the class object
  return $clss->new_from_primary_resultset_row($prim);
};

sub export {
  my $clss = shift;
  my @keys = @_;
  
  # find the primitive for this class
  my $list = $clss->storage_engine->resultset(PRIMARY_RESULTSET)
    ->search_rs(undef) or return undef;
    
  # create the class set
  return RESOURCE_SET->new( {
    _proxy_set => $list,
    _resource_object_class      => RESOURCE_OBJECT,
    _resource_datastore_class   => __PACKAGE__,
  } );
};

sub inflate {
  my $prim = shift;
  
  # inflate class attributes with primitive columns
  my $prms = {
    _proxy              => $prim,
    _ID                 => $prim->get_column('user_id'),
    login_name          => $prim->get_column('login'),
    first_name          => $prim->get_column('first_name'),
    nick                => $prim->get_column('nick_name'),
    biography           => {},
  };
  
  # search localized data
  my @lclz = $prim->search_related('bios')->all;
  
  # inflate class attributes with multilingual hashes
  foreach my $locl (@lclz) {
    $prms->{'biography'}
      ->{$locl->lang} = $locl->get_column('bio');
  };
  
  return $prms
};

sub new_from_primary_resultset_row {
  my $clss = shift;
  my $prim = shift;
  return RESOURCE_OBJECT->new(inflate($prim));
}

1;

