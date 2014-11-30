package Act::API;

use Moo;
use MooX::Types::MooseLike::Base qw<Int Str Object>;
use Carp;
use JSON;
use Try::Tiny;
use HTTP::Tiny;
use Act::Entity::Event;

with 'Act::Abstract';

has ua => (
    is      => 'ro',
    isa     => Object,
    lazy    => 1,
    builder => '_build_ua',
);

has domain => (
    is      => 'ro',
    isa     => Str,
    default => sub {'localhost'},
);

has port => (
    is      => 'ro',
    isa     => Int,
    default => sub {5050},
);

has base_url => (
    is      => 'ro',
    lazy    => 1,
    default => sub {
        my $self = shift;
        return sprintf 'http://%s:%s', $self->domain, $self->port;
    },
);

sub _build_ua { HTTP::Tiny->new }

sub _request {
    my ( $self, $url ) = @_;
    my $base   = $self->base_url;
    my $result = $self->ua->get( "$base/$url" );

    $result->{'success'}
        or croak "Request to $base/$url failed: " . $result->{'reason'};

    my $data = try   { decode_json $result->{'content'}  }
               catch { die "Decoding content failed: $_" };

    return $data;
}

sub event {
    my ( $self, $args, $params ) = @_;

    my $url    = join '/', $args->{'conf_id'}, 'event', $args->{'event_id'};
    my $result = $self->_request($url);
    return Act::Entity::Event->new($result);
}

1;
