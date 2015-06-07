package Act::Next::DataStore::Users;

use constant RESOURCE_OBJECT    => "Act::Next::Object::User";
use constant RESOURCE_SET       => "Act::Next::Set::Users";
use constant PRIMARY_RESULTSET  => "User";

use Moo;

extends 'Act::Next::DataStore';

use Class::Load 'load_class';

load_class(RESOURCE_OBJECT);
load_class(RESOURCE_SET);

our $prim_columns = {
    _ID                 => 'user_id',
    login_name          => 'login',
    nick                => 'nick_name',
    first_name          => 'first_name',
};

sub ResourceSetExport {
    return ( qw |first_name nick_name| )
};

sub insert {
  my $clss = shift;
  my $objt = shift;
  
  # create the primitive in the storage
  my $rslt = $clss->storage_engine->resultset(PRIMARY_RESULTSET)
    ->create( {
      'login'           => $objt->{'login_name'},
      'first_name'      => $objt->{'first_name'},
      'nick_name'       => $objt->{'nick'},
    } );
  
  # create related language variants for each recorded mutation
  foreach my $lang (keys %{ $objt->_multilingual_mut } ) {
    $rslt -> create_related ('bios', {
      'lang'            => $lang,
      'bio'             => $objt->{'biography'}->{$lang},
    } );
    delete $objt->_multilingual_mut->{$lang}; # has been handled now
  };
  
  return $rslt->get_column('login_name');
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

sub update {
  my $clss = shift;
  my $objt = shift;
  
  # deflate class object into primitive proxy and update
  $objt->_proxy->set_column('login'           => $objt->{'login_name'});
  $objt->_proxy->set_column('first_name'      => $objt->{'first_name'});
  $objt->_proxy->set_column('nick_name'       => $objt->{'nick'});
  $objt->_proxy->update;
  
  # itterate over all 'recorded mutations'
  foreach my $lang (keys %{ $objt->_multilingual_mut } ) {
  
    # check if there is
    my $rslt = $objt->_proxy->find_related ('bios', {
      'lang'    => $lang});
    if ($rslt) { # is there a localized version
      if ($objt->_multilingual_mut->{$lang}) { # does it need update
        $rslt->set_column('bio'         => $objt->{'biography'}->{$lang});
        $rslt->update;
      }
      else { # it does not need update, it needs delete
        $rslt->delete;
      }
    }
    else { # no translation available
      if ($objt->_multilingual_mut->{$lang}) { # does it need update
        $rslt = $objt->_proxy->create_related ('bios', {
          'lang'            => $lang,
          'bio'             => $objt->{'biography'}->{$lang},
        } );
      }
      else { # that is weird ... delete straight after new translation
      }
    }
    delete $objt->_multilingual_mut->{$lang}; # has been handled now
  };
  return;
};

sub remove {
  my $clss = shift;
  my $objt = shift;
  
  # remove the entire record, first the related, then the primitive
  # this might be handled by proper DB cascading
  $objt->_proxy->delete_related ('bios');
  $objt->_proxy->delete;
  return;
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

