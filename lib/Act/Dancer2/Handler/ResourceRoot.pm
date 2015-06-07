package Act::Dancer2::Handler::ResourceRoot;

=head1 NAME

Act::Dancer2::Handler::ResourceRoot

REST api requests are done within a context of a resource root and the user
making the request. A ResourceRoot object usually has a Syndicate and an
Edition ie. /yapc-eu/2015 (in contrast to what it used to be... ye2015).

The Syndicate or Edition roles will be applied at instantion.

=cut

use Moo;

use Act::Config;
use Act::Schema;

our $ActSchema = Act::Schema->connect(
    $Config->database_dsn,
    $Config->database_user,
    $Config->database_passwd,
    undef
);

has syndicate => (
    is          => 'ro',
);

has edition => (
    is          => 'ro',
);

has _act_conf_id => (
    is          => 'ro',
);

has _act_conference => (
    is          => 'ro',
);

sub new_from_http_request {
    my $class = shift;
    my $request = shift;
    
    my $synd = $request->header('x-act-syndicate');
    my $edtn = $request->header('x-act-edition');
    my $conf = $request->header('x-act-conference');
    
    my $evnt = $ActSchema->resultset('Conference')->find({
        conf_id => $conf,
    });
    
    my $resource_root = __PACKAGE__->new( {
        syndicate       => $synd,
        edition         => $edtn,
        _act_conf_id    => $conf,
        _act_conference => $evnt,
    } );
    
    if ($evnt) {
        Role::Tiny->apply_roles_to_object($resource_root,
            ('Act::Dancer2::Handler::ResourceRoot::Role::Event'));
    }
    elsif ($edtn) { # that is odd, how can a edition NOT be an event?
        Role::Tiny->apply_roles_to_object($resource_root,
            ('Act::Dancer2::Handler::ResourceRoot::Role::Edition'));
    }
    elsif ($synd) {
        Role::Tiny->apply_roles_to_object($resource_root,
            ('Act::Dancer2::Handler::ResourceRoot::Role::Syndicate'));
    }
    else {
        Role::Tiny->apply_roles_to_object($resource_root,
            ('Act::Dancer2::Handler::ResourceRoot::Role::Resource'));
    };
    
    return $resource_root;
    
}

1;
