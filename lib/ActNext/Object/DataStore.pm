package ActNext::Object::DataStore;

use Moo;

has storage_engine => (
  is => 'ro'
);

# methods that should handle default behaviour
# if not provided by the NextDataStore subclass

sub insert { };

sub lookup {
    my $clss = shift;
    my @keys = @_;
    
    # find the primitive for this class
    my $prim = $clss->storage_engine->resultset($clss->_PRIMARY_RESULTSET)
        ->find(@keys) or return undef;
    
    # create the class object
    return $clss->new_from_primary_resultset_row($prim);
};

sub update { };
sub remove { };
sub search { };
sub export {
    my $clss = shift;
    my @keys = @_;
    
    # find the primitive for this class
    my $list = $clss->storage_engine->resultset($clss->_PRIMARY_RESULTSET)
        ->search_rs(@keys) or return undef;
    
    # create the class set
    return $clss->_OBJECT_SET->new( { _proxy_set => $list } );
};

sub export_joined {
    my $clss = shift;
    my $join = shift;
    my @keys = @_;
    
    # find the primitive for this class
    my $list = $clss->storage_engine->resultset($clss->_PRIMARY_RESULTSET)
        ->search_rs(@keys, { join => $join }) or return undef;
    
    # create the class set
    return $clss->_OBJECT_SET->new( { _proxy_set => $list } );
};

sub entire { my $prompt = "ALL"; use DDP; p $prompt; return};

sub inflated_hash {
  my $clss = shift;
  my $prim = shift;
  
  # inflate class attributes with primitive columns
  my $prms = {};
  $prms->{_proxy} = $prim;
  $prms->{_INDEX} = $prim->get_column($clss->_PRIMARY_INDEX) if $clss->_PRIMARY_INDEX;
  foreach ($clss->_attributes_simple) {
    $prms->{$_} = $prim->get_column($clss->_ATTRIBUTES->{$_})
  }
  
  return $prms
};

sub _attributes_simple {
    my $clss = shift;
    
    return grep {ref $clss->_ATTRIBUTES->{$_} eq ""}
        (keys %{$clss->_ATTRIBUTES});
    
}

sub attributes_multilingual { (
) };



1;
