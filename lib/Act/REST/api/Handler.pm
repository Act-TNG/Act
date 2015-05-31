package Act::REST::api::Handler;

=head1 NAME

Act::REST::api::Handler;

The Handler object will have (after instantiation) one or more roles applied
to it, so it knows which methods it can use on behalve of the ClientUser in the
context of the current ResourceRoot.

Think of if like a total anonymous user, a signed-in user or a user that has
specific roles been assigned to a specific Community Event, like Treasurer or
Schedule manager.

See C<Act::REST::api::Handler::Role:: ...> for the various roles

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

use constant PACKAGE_USER => 'Act::REST::api::ClientUser';
use constant PACKAGE_ROOT => 'Act::REST::api::ResourceRoot';
use constant PACKAGE_SELF => 'Act::REST::api::Handler';

load_class PACKAGE_USER;
load_class PACKAGE_ROOT;

our $role_table = {
    admin       => [ 'Act::REST::api::Handler::Role::Event::MainAdmin' ],
    users_admin => [ 'Act::REST::api::Handler::Role::Event::UserSupport' ],
    wiki_admin  => [ ],
    talks_admin => [ ],
#    news_admin  => [ 'Act::REST::api::Handler::Role::Event::Media' ],
    staff       => [ ],
    treasurer   => [ 'Act::REST::api::Handler::Role::Event::Treasurer' ],
};

use Act::REST::api;

our $_RESTapi = Act::REST::api->new();

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
        unless (exists $role_table->{$right_id}) {
            warn "Legacy rights not in lookup table: '$right_id'";
            next;
        };
        foreach my $role (@{$role_table->{$right_id}}) {
            $roles->{$role} += 1;
        };
    };
    
use DDP; p $roles;
    Role::Tiny->apply_roles_to_object($handler, keys %$roles) if keys %$roles;
    
   Role::Tiny->apply_roles_to_object($handler,
       ('Act::REST::api::Handler::Role::Event::Public'));

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

sub datastore {
    my $self = shift;
    return $_RESTapi->datastore(shift);
}

sub object {
    my $self = shift;
    return $_RESTapi->object(shift);
}

1;
