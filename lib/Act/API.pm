package Act::API;
# Interface to the Act system

use Moo;
use MooX::Types::MooseLike::Base qw<Str HashRef InstanceOf>;

use Scalar::Util 'weaken';
use Act::Schema;

has dsn => (
    is       => 'ro',
    isa      => Str,
    required => 1,
);

has schema => (
    is      => 'ro',
    isa     => InstanceOf['Act::Schema'],
    lazy    => 1,
    builder => '_build_schema',
);

has schema_options => (
    is      => 'ro',
    isa     => HashRef,
    default => sub { +{} },
);

sub _build_schema {
    my $self = shift;
    return Act::Schema->connect( $self->dsn, $self->schema_options );
}

sub add_tags_to_talk {
    my ( $self, $args ) = @_;

    my %old_tags = map  +( $_->tag => 1 ), $args->{'talk'}->tags->all();
    my @new_tags = grep +( !$old_tags{$_} ), split_tags( $args->{'new_tags'} );

    foreach my $tag (@new_tags) {
        Act::Entity::Tag->new(
            act     => $self,
            conf_id => $args->{'conf_id'},
            tag     => $tag,
            type    => 'talk',
        )->save;
    }
}

1;
