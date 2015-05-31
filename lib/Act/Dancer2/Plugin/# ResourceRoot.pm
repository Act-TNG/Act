package Act::Dancer2::Plugin::ResourceRoot;

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

on_plugin_import {
    my $dsl = shift;
    $dsl->app->add_hook( Dancer2::Core::Hook->new(
        name => 'before',
        code => sub {
            my $dsl = shift;
            my $synd = $dsl->request->header('x-act-syndicate');
            my $edtn = $dsl->request->header('x-act-edition');
            my $conf = $dsl->request->header('x-act-conference');
#             unless ($conf) {
# carp "not a conference";
#                 status(404); # Not Found
#                 halt;
#             }
            my $evnt = $ActSchema->resultset('Conference')->find( {
                conf_id => $dsl->request->header('x-act-conference') || 0,
            } );
use Carp; carp 'vvvv event';
use DDP; p $evnt;
use Carp; carp '^^^^ event';
        },
    ));
};

register_plugin;

1;