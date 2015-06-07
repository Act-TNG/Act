package Act::Next::DataStore;

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
        ->search_rs(undef) or return undef;
    
    # create the class set
    return $clss->_RESOURCE_SET->new( { _proxy_set => $list } );
};
sub entire { my $prompt = "ALL"; use DDP; p $prompt; return};

1;
