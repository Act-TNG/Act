package Act::Entity::Talk;
# ABSTRACT: An entity representing a talk

use Moo;
use MooX::Types::MooseLike::Base qw<Bool>;
with qw<
    Act::Role::Entity
    Act::Role::Entity::HasConference
>;

has accepted => (
    is      => 'ro',
    isa     => Bool,
    default => sub {0},
);

has tags => (
    is      => 'ro',
    isa     => InstanceOf['DBIx::Class::ResultSet::Tag'],
    lazy    => 1,
    builder => '_build_tags',
);

sub _build_tags {
    my $self = shift;
    $self->schema->resultset('Tag')->search({
        conf_id   => $self->conference->id,
        type      => 'talk',
        tagged_id => $self->id,
    });
}

sub presenters { shift->user_id }

sub displayable {
    my $self   = shift;
    my $config = $self->config;

    # open submissions
    $config->{'show_all'} and return 1;

    # talk accepted
    $self->accepted and return 1;

    # talk administator
    $config->{'user'}->is_talks_admin and return 1;

    # talk submitter
    $config->{'user'}->user_id eq $self->user_id and return 1;

    return 0;
}

1;

__END__

=head1 METHODS

=head2 displayable

Can we display a talk?

We decide this according to four options:

=over 4

=item * If submissions are open for the public

=item * If the talk is accepted

=item * If the user is a talk administrator

=item * If the user is the submitter

=back

