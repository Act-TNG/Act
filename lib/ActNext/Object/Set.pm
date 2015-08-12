package Act::Next::Set;

use Moo;

has _proxy_set => (
  is => 'ro'
);

# methods that should handle default behaviour
# if not provided by the NextSet subclass

sub first {
    use DDP; p @_;
    my $self = shift;
    my $prim = $self->_proxy_set->first;
    
    return $self->_RESOURCE_DATASTORE->new_from_primary_resultset_row($prim);
};

sub next {
    my $self = shift;
    my $prim = $self->_proxy_set->next;
    return undef unless $prim;
    
    return $self->_RESOURCE_DATASTORE->new_from_primary_resultset_row($prim);
}
sub count { shift->_proxy_set->count}

################################################################################
#
# Again... not our responsabillity
#
################################################################################

sub _to_json_list {
    my $self = shift;
    my $export = $self->_RESOURCE_DATASTORE->ResourceSetExport( );
    
}
1;
