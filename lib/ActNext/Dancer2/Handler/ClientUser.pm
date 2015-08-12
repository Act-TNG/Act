package ActNext::Dancer2::Handler::ClientUser;

=head1 NAME

ActNext::Dancer2::Handler::ClientUser

The user object that represents the 'user' from the api.

Note that a ClientUser does not need to have a mapping to a user in Act, for
example an anonymous guest.

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

use HTTP::Headers::ActionPack::Authorization;
use Digest::MD5;

has client_username => (
    is                  => 'ro',
#   isa                 => 'Str',
);

has client_password => (
    is                  => 'ro',
#   isa                 => 'Any',
);

has _act_user => (
    is                  => 'ro',
#   isa                 => 'ActNext::Schema::Result::User',
);

sub new_from_http_request {
    my $class = shift;
    my $request = shift;
    
    my $auth = undef;
    
    if ($request->header('Authorization')) {
        $auth = HTTP::Headers::ActionPack::Authorization::Basic
            ->new_from_string($request->header('Authorization'));
    }
    
    my $client_user = undef;
    
    if (!$auth) { # Anonymous acces
        $client_user = $class->new({
            client_username => undef,
            client_password => undef,
            _act_user       => undef,
        });
        Role::Tiny->apply_roles_to_object($client_user,
            ('ActNext::Dancer2::Handler::ClientUser::Role::Anonymous'));
        return $client_user;
    }
    
    my $username = $auth->username;
    my $password = $auth->password;
    my $MD5crypt = _crypt_password($password);
    my $act_user = $ActSchema->resultset('User')
        ->search({ login => $username, passwd => $MD5crypt })->first;
    
    if (!$act_user) { # Suspected login
        $client_user = $class->new({
            client_username => $username,
            client_password => $password,
            _act_user       => undef,
        });
        Role::Tiny->apply_roles_to_object($client_user,
            ('ActNext::Dancer2::Handler::ClientUser::Role::Suspected'));
        return $client_user;
    }
    else { # Apparently... a authenticated user
        $client_user = $class->new({
            client_username => $username,
            client_password => $password,
            _act_user       => $act_user,
        });
        Role::Tiny->apply_roles_to_object($client_user,
            ('ActNext::Dancer2::Handler::ClientUser::Role::Authenticated'));
        return $client_user;
    }
    
    die;
};

sub _crypt_password {
    my $digest = Digest::MD5->new;
    $digest->add(shift);
    return $digest->b64digest();
}

1;

