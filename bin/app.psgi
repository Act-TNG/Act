#!/usr/bin/env perl

use FindBin;
use lib "$FindBin::Bin/../lib";

use Dancer2;
use Act::Web;
use Act::Schema;
use Plack::Builder;
use Plack::Middleware::Rewrite;

builder {
    enable 'Rewrite', rules => sub {
        my $schema   = Act::Schema->connect( config->{'dsn'} );
        my $event_id = $_ =~ qr{^ / ([^/]+) }x;
        my $conf     = $schema->resultset('Event')->find({
            id => $event_id
        }) or do {
            $_ = '/';
            return 301;
        };

        return;
    };

    Act::Web->to_app;
};
