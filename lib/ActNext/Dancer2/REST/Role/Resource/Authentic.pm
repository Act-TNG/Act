package ActNext::Dancer2::REST::Role::Resource::Authentic;

=head1 NAME

ActNext::Dancer2::REST::Role::Resource::Authentic

The C<Authentic> role provides an interface for all ClientUsers

=cut

use Moo::Role;

# more methods will get added for which no authentication is required

sub lookup_user {
    shift->api
        ->resource('Users')
        ->lookup(@_)
};

sub export_user {
    shift->api
        ->resource('Users')
        ->export(@_)
};

sub export_user_for_talk {
    shift->api
        ->resource('Talks')
        ->export_user(@_)
};

sub lookup_talk {
    shift->api
        ->resource('Talks')
        ->lookup(@_)
};

1;

