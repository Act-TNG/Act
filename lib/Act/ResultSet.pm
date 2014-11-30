package Act::ResultSet;
# ABSTRACT: Act object for representing entity resultsets

use Moo;
use MooX::Types::MooseLike::Base qw<Bool Int Str ArrayRef>;
use Class::Load 'load_class';

has type => (
    is       => 'ro',
    isa      => Str,
    required => 1,
);

has items => (
    is       => 'ro',
    isa      => ArrayRef,
    required => 1,
);

has scroller => (
    is      => 'ro',
    isa     => Bool,
    default => sub {0},
);

has total => (
    is      => 'ro',
    isa     => Int,
    default => sub {
        my $self = shift;
        $self->scroller ? -1 : scalar @{ $self->items };
    },
);

sub all {
    my $self  = shift;
    my @items = ();

    while ( my $item = $self->next ) {
        push @items, $item;
    }

    return @items;
}

sub next {
    my $self = shift;
    my $item = shift @{ $self->items };

    defined $item or return;

    my $class = 'Act::Entity::' . ucfirst $self->type;
    load_class($class);

    return $class->new($item);
}

1;
