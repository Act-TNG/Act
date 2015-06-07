package Act::Dancer2::REST::Role::Event::Authentic;

=head1 NAME

Act::Dancer2::REST::Role::Event::Authentic

The C<Authentic> role provides an interface for all ClientUsers

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

1;

