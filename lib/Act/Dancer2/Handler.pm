package Act::Dancer2::Handler;

=head1 NAME

Act::Dancer2::Handler;

The Handler object will have (after instantiation) one or more roles applied
to it, so it knows which methods it can use on behalve of the ClientUser in the
context of the current ResourceRoot.

Think of if like a total anonymous user, a signed-in user or a user that has
specific roles been assigned to a specific Community Event, like Treasurer or
Schedule manager.

See C<Act::Dancer2::Handler::Role:: ...> for the various roles

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

use Class::Load 'load_class';

use constant PACKAGE_USER   => 'Act::Dancer2::Handler::ClientUser';
use constant PACKAGE_ROOT   => 'Act::Dancer2::Handler::ResourceRoot';
use constant PACKAGE_SELF   => 'Act::Dancer2::REST';

use constant LANGUAGES      => qw| en nl fr es de ru no |;

load_class PACKAGE_USER;
load_class PACKAGE_ROOT;

our $roles_event = {
    admin       => [ 'Act::Dancer2::REST::Role::Event::MainAdmin' ],
    users_admin => [ 'Act::Dancer2::REST::Role::Event::UserSupport' ],
    wiki_admin  => [ ],
    talks_admin => [ ],
#   news_admin  => [ 'Act::Dancer2::REST::Role::Event::Media' ],
    staff       => [ ],
    treasurer   => [ 'Act::Dancer2::REST::Role::Event::Treasurer' ],
    _anonymous_ => [ 'Act::Dancer2::REST::Role::Event::Anonymous' ],
    _suspected_ => [ 'Act::Dancer2::REST::Role::Event::Suspected' ],
    _authentic_ => [ 'Act::Dancer2::REST::Role::Event::Authentic' ],
};

our $roles_resource = {
    _anonymous_ => [ 'Act::Dancer2::REST::Role::Resource::Anonymous' ],
    _suspected_ => [ 'Act::Dancer2::REST::Role::Resource::Suspected' ],
    _authentic_ => [ 'Act::Dancer2::REST::Role::Resource::Authentic' ],
};

use Act::Next;

our $_RESTapi = Act::Next->new( default_languages => [ 'en', 'nl', 'fr' ] );

has client_user => (
    is          => 'ro',
#   isa         => PACKAGE_USER,
);

has resource_root => (
    is          => 'ro',
#   isa         => PACKAGE_ROOT,
);

has _permissions => ( # legacy
    is          => 'ro',
);

sub new_from_http_request {
    my $class = shift;
    my $request = shift;
    
    my $resource_root = PACKAGE_ROOT
        ->new_from_http_request($request);
    
    my $client_user = PACKAGE_USER
        ->new_from_http_request($request);
    
    my $handler = __PACKAGE__->new({
        resource_root => $resource_root,
        client_user   => $client_user,
    });
    
    my @rights;
    if (
        $handler->root_does_role('Event')
        and
        $handler->user_does_role('Authenticated')
    ) {
        @rights = $ActSchema->resultset('Right')->search({
            conf_id => $resource_root->_act_conference->conf_id,
            user_id => $client_user->_act_user->user_id
        })->all;
    }
    
    # Apply roles
    my $roles = { };
    
    foreach my $right (@rights) {
        my $right_id = $right->right_id;
        _add_roles( {
            handler     => $handler,
            roles       => $roles,
            right_id    => $right_id,
        });
    };
    
    if ($handler->user_does_role('Suspected')) {
        my $right_id = '_suspected_';
        _add_roles( {
            handler     => $handler,
            roles       => $roles,
            right_id    => $right_id,
        });
    };
    if ($handler->user_does_role('Anonymous')) {
        my $right_id = '_anonymous_';
        _add_roles( {
            handler     => $handler,
            roles       => $roles,
            right_id    => $right_id,
        });
    };
    if ($handler->user_does_role('Authenticated')) {
        my $right_id = '_authentic_';
        _add_roles( {
            handler     => $handler,
            roles       => $roles,
            right_id    => $right_id,
        });
    };
    
    Role::Tiny->apply_roles_to_object($handler, keys %$roles) if keys %$roles;
    
    return $handler;
};

sub user_does_role {
    my $self = shift;
    return $self->client_user
        ->does(PACKAGE_USER . "::Role::" . shift);
}

sub root_does_role {
    my $self = shift;
    return $self->resource_root
        ->does(PACKAGE_ROOT . "::Role::" . shift);
}

sub self_does_role {
    my $self = shift;
    return $self
        ->does(PACKAGE_SELF . "::Role::" . shift);
}

sub self_able_task {
    my $self = shift;
    return $self
        ->can(shift);
}

sub resource_datastore {
    my $self = shift;
    return $_RESTapi->resource_datastore(shift);
}

sub resource_object {
    my $self = shift;
    return $_RESTapi->resource_object(shift);
}

sub resource_set {
    my $self = shift;
    return $_RESTapi->resource_set(shift);
}

sub api {
    my $self = shift;
    return $_RESTapi;
}

sub _add_roles {
    my $params = shift;
    
    if ($params->{handler}->root_does_role('Event')) {
        unless (exists $roles_event->{$params->{right_id}}) {
            warn "Legacy rights not in lookup table: '$params->{right_id}'";
        }
        else {
            foreach my $role (@{$roles_event->{$params->{right_id}}}) {
                $params->{roles}->{$role} += 1;
            }
        };
    };
    if ($params->{handler}->root_does_role('Resource')) {
        unless (exists $roles_resource->{$params->{right_id}}) {
            warn "Legacy rights not in lookup table: '$params->{right_id}'";
        }
        else {
            foreach my $role (@{$roles_resource->{$params->{right_id}}}) {
                $params->{roles}->{$role} += 1;
            }
        };
    };
    
    return;
}

our @_backup_languages = LANGUAGES;
sub _backup_languages {
    return ( @_backup_languages );
}

1;
