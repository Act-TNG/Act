package ActNext::Object::DataStore::Users;

use constant _OBJECT_ITEM       => "ActNext::Object::Item::User";
use constant _OBJECT_SET        => "ActNext::Object::Set::Users";
use constant _PRIMARY_RESULTSET => "User";
use constant _PRIMARY_INDEX     => "user_id";
use constant _ATTRIBUTES        => {
    login_name          => 'login',
    nick                => 'nick_name',
    first_name          => 'first_name',
    biography           => {
        multilingual => {
            table       => 'bios',
            column      => 'bio',
            language_id => 'lang'},
        },
};


use Moo;

extends 'ActNext::Object::DataStore';

use Class::Load 'load_class';

load_class(_OBJECT_ITEM);
load_class(_OBJECT_SET);

sub attributes_multilingual { (
    'biography', 
) };

sub insert {
  my $clss = shift;
  my $objt = shift;
  
  # create the primitive in the storage
  my $rslt = $clss->storage_engine->resultset(_PRIMARY_RESULTSET)
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

# sub lookup {
# };

sub update {
  my $clss = shift;
  my $objt = shift;
  
  # deflate class object into primitive proxy and update
  $objt->_proxy->set_column('login'           => $objt->{'login_name'});
  $objt->_proxy->set_column('first_name'      => $objt->{'first_name'});
  $objt->_proxy->set_column('nick_name'       => $objt->{'nick'});
  $objt->_proxy->update;
  
  # iterate over all 'recorded mutations'
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

sub inflated_hash {
  my $self = shift;
  my $prim = shift;
  
  # inflate class attributes with primitive columns
  my $prms = {};
  $prms->{_proxy} = $prim;
  $prms->{_INDEX} = $prim->get_column(_PRIMARY_INDEX);
  foreach ($self->_attributes_simple) {
    $prms->{$_} = $prim->get_column($self->_ATTRIBUTES->{$_})
  }
  $prms->{biography} = {};
  
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
  my $self = shift;
  my $prim = shift;
  return _OBJECT_ITEM->new($self->inflated_hash($prim));
}

1;

