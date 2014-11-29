package Act::Legacy::User;

use Digest::MD5 qw( md5_hex );
use namespace::clean;

use Moo;

with 'Act::Role::Legacy';

# basic attributes
has [ Act::Schema->source('User')->columns ] => ( is => 'ro' );

has talks => (
    is => 'lazy',
);

sub _build_talks {
    my ($self) = @_;
    return [
        $self->act->_schema->search_rs('Talk')->search(
            { 'me.user_id' => $self->user_id },
            { result_class => 'Act::Legacy::Talk' }
            )->all
    ];
}

sub inflate_result {
    my ( $self, undef, $me, $fetch ) = @_;

    my $user = $self->new( $me );

    if( exists $fetch->{talks} ) {
        my @talks = map Act::Legacy::Talk->inflate_result( undef, @$_ ),
            @{ $fetch->{talks} };
        $user->_set_talks( \@talks );
    }
}

# sub get_items

# sub rights {

# sub full_name

sub country_name { Act::Country::CountryName( $_[0]->country ) }

# sub public_name

has bio => ( is => 'lazy' );
sub _build_bio {
    my ($self) = @_;
    return {
        map { $_->[0] => $_->[1] }
            $self->act->storage->_search_rs('Bio')->search(
            { user_id => $self->user_id },
            { columns => [qw( lang bio )] },
            )->cursor->all
    };
}

has md5_email => ( is => 'lazy' );
sub _build_md5_email {
    Digest::MD5->new->add( lc shift->email )->hexdigest;
}

# sub talks
# sub participation

has my_talks => ( is => 'lazy' );

sub _build_my_talks {
    my ($self) = @_;
    return [
        $self->act->storage->schema->search_rs('UserTalk')
            ->search( { 'me.user_id' => $self->user_id, } )->search_related(
            'talk' => { -bool => 'talk.accepted' },
            { result_class => 'Act::Legacy::Talk' }
            )->all
    ];
}

# sub update_my_talks

sub is_my_talk { # FIXME
    my ($self, $talk_id) = @_;
    return first { $_->talk_id == $talk_id } @{ $self->my_talks };
}

# sub attendees

sub committed {
    my $self = shift;
    return $self->has_paid
        || $self->has_attended
        || $self->has_accepted_talk
        || $self->is_staff
        || $self->is_users_admin
        || $self->is_talks_admin
        || $self->is_news_admin
        || $self->is_wiki_admin;
}

# sub participations {
# sub conferences {
# sub create {
# sub update {
# sub possible_duplicates {
# sub most_recent_participation {

1;

