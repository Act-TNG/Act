package Act::Dancer2::REST::Role::Resource::Anonymous;

=head1 NAME

Act::Dancer2::REST::Role::Resource::Anonymous

The C<Anonymous> role provides an interface for all ClientUsers

=cut

use Moo::Role;

# more methods will get added for which no authentication is required

sub lookup_user {
    shift->api
        ->resource('Users')
        ->lookup(@_)
};

sub lookup_talk {
    shift->api
        ->resource('Talks')
        ->lookup(@_)
};

1;

