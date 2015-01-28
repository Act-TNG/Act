#!/usr/bin/env perl

use FindBin;
use lib "$FindBin::Bin/../lib";

use strict;
use warnings;

use Act::Config;

use Getopt::Long    qw< :config no_auto_abbrev no_ignore_case >;
use Term::ANSIColor qw< :constants >;
use DDP;

# constants
use constant {
    DEFAULT_NUMBER_PAYMENTS  =>  10,
    RECENTNESS_THRESHOLD     =>   3, # hours
    TIME_ZONE                => "UTC",
};

use constant LANGUAGES     => qw(de en fr hu it pt nl);
use constant TEMPLATE_DIRS => qw(static templates);

for my $conf_id (sort keys %{$Config->conferences}) {
    $Request{conference} = $conf_id;
    my $ConfConfig = Act::Config::get_config($Request{conference});
p $ConfConfig->home;
p $ConfConfig->name->{'nl'};
p $ConfConfig->payment_type;
p $ConfConfig->type_payment;
p $conf_id;
}
