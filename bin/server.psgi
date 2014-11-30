#!perl

use Dancer2;
use Act::Web::API;

if ( Dancer2->runner->environment eq 'development' && config->{'trace'} ) {
    $ENV{'DBIC_TRACE'} = 1;
    $ENV{'DBIC_TRACE_PROFILE'} = 'console';
}

Act::Web::API->setup();
Act::Web::API->to_app;
