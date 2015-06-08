package Act::Dancer2::REST::Role::Event::Anonymous;

=head1 NAME

Act::Dancer2::REST::Role::Event::Anonymous

The C<Anonymous> role provides an interface for all ClientUsers

=cut

use Moo::Role;

# more methods will get added for which no authentication is required

# sub lookup_syndicate {
#     shift->api
#         ->datastore('Syndicates')
#         ->lookup(@_)
# };
# 
# sub lookup_edition {
#     shift->api
#         ->datastore('Editions')
#         ->lookup(@_)
# };

### lookup_user... did you mean participant

sub lookup_talk {
    shift->api
        ->resource('Talks')
        ->lookup(@_)
};

sub lookup_user {
    shift->api
        ->resource('Users')
        ->lookup(@_)
};

sub export_talks {
    my $hndl = shift;
    $hndl->api
        ->resource('Talks')
        ->export({conf_id => $hndl->resource_root->{_act_conf_id}})
};

sub export_attendees_for_event {
    my $hndl = shift;
    
    my $rslt = $hndl->api
        ->resource('Users')
        ->export_joined('participations', {
            'participations.conf_id' => $hndl->resource_root->{_act_conf_id},
        })
};

sub export_participations_for_event {
    my $hndl = shift;
    $hndl->api
        ->resource('Participations')
        ->export({conf_id => $hndl->resource_root->{_act_conf_id}})
};


1;

