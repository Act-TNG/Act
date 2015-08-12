package Act::Dancer2::Plugin::HTTP::Auth;

use warnings;
use strict;

use Dancer2::Plugin;

use Act::Config;
use Act::Schema;

our $ActSchema = Act::Schema->connect(
    $Config->database_dsn,
    $Config->database_user,
    $Config->database_passwd,
    undef
);

use constant HTTP_AUTH_REALM    => 'Act Voyager';
use constant HTTP_AUTH_SCHEME   => 'Basic';
use constant HTTP_REQUIRE_ROLE  => '_ROLE_';
use constant HTTP_REQUIRE_TASK  => '_TASK_';
use constant HTTP_REQUIRE_ANY   => '_ANY_';
use constant HTTP_REQUIRE_ALL   => '_ALL_';
use constant HTTP_REQUIRE_ONE   => '_ONE_';

use Act::Dancer2::Handler;

use List::Util;

on_plugin_import {
    my $dsl = shift;
    $dsl->app->add_hook( Dancer2::Core::Hook->new(
        name => 'before',
        code => sub { 
            my $app = shift;
            my $handler = Act::Dancer2::Handler
                ->new_from_http_request($dsl->request);
            $dsl->vars->{http_auth_handler} = $handler;
        },
    ));
};

register http_require_authentication => sub {
    my $dsl     = shift;
    my $coderef = shift;
    
    return sub {
        unless ( $coderef && ref $coderef eq 'CODE' ) {
            return sub {
               warn "Invalid http_require_authentication usage";
            };
        }
        my $handler = $dsl->vars->{http_auth_handler};
        unless ( $handler ) {
            return sub {
                warn "Invalid http_require_authentication usage";
            };
        };
        unless ( $handler->user_does_role('Authenticated') ) {
            return &_http_status_unauthorized($dsl)
        };
        return $coderef->($dsl);
    };
};

register http_require_role => sub {
    return _http_require(@_, HTTP_REQUIRE_ROLE, HTTP_REQUIRE_ONE);
};

register http_require_role_any => sub {
    return _http_require(@_, HTTP_REQUIRE_ROLE, HTTP_REQUIRE_ANY);
};

register http_require_role_all => sub {
    return _http_require(@_, HTTP_REQUIRE_ROLE, HTTP_REQUIRE_ALL);
};

register http_require_task => sub {
    return _http_require(@_, HTTP_REQUIRE_TASK, HTTP_REQUIRE_ONE);
};

register http_require_task_any => sub {
    return _http_require(@_, HTTP_REQUIRE_TASK, HTTP_REQUIRE_ANY);
};

register http_require_task_all => sub {
    return _http_require(@_, HTTP_REQUIRE_TASK, HTTP_REQUIRE_ALL);
};

sub _http_require {
    my $dsl     = shift;
    my $matches = shift;
    my $coderef = shift;
    my $require = shift;
    my $mode    = shift;
    
    return sub {
        unless ( $coderef && ref $coderef eq 'CODE' ) {
            return sub {
                warn "Invalid http_require_can usage";
            }
        };
        my $handler = $dsl->vars->{http_auth_handler};
        unless ( $handler ) {
            return sub {
                warn "Invalid http_require_... usage";
            }
        };
        # check if we pass
        my $pass = undef;
        my @matches = (ref $matches eq 'ARRAY') ? @$matches : ($matches);
        
        if ($mode eq HTTP_REQUIRE_ONE) {
            $pass = List::Util::first {
                HTTP_REQUIRE_ROLE eq $require && $handler->self_does_role($_)
                or
                HTTP_REQUIRE_TASK eq $require && $handler->self_able_task($_)
            } @matches;
        };
        if ($mode eq HTTP_REQUIRE_ALL) {
            $pass = List::Util::all {
                HTTP_REQUIRE_ROLE eq $require && $handler->self_does_role($_)
                or
                HTTP_REQUIRE_TASK eq $require && $handler->self_able_task($_)
            } @matches;
        };
        if ($mode eq HTTP_REQUIRE_ANY) {
            $pass = List::Util::any {
                HTTP_REQUIRE_ROLE eq $require && $handler->self_does_role($_)
                or
                HTTP_REQUIRE_TASK eq $require && $handler->self_able_task($_)
            } @matches;
        };
        
        unless ( $pass ) {
            return &_http_status_unauthorized($dsl)
                unless $handler->user_does_role('Authenticated');
            return &_http_status_forbidden($dsl);
        };
        return $coderef->($dsl);
    };
};

register http_auth_handler => sub {
    my $dsl = shift;
    return $dsl->vars->{http_auth_handler};
};

sub _http_status_unauthorized {
    my $dsl = shift;    
    $dsl->header('WWW-Authenticate' =>
        HTTP_AUTH_SCHEME . 'realm="' . HTTP_AUTH_REALM . '"');
    $dsl->status(401); # Unauthorized
    return
        'Authentication required to access realm: '
    .   '"' . HTTP_AUTH_REALM . '"';
};

sub _http_status_forbidden {
    my $dsl = shift;
    $dsl->status(403); # Forbidden
    return
        qq|Permission denied for resource: |
    .   qq|'@{[ $dsl->request->path ]}'|;
};

register_plugin;

1;
