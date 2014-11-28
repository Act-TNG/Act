#!/usr/bin/env perl

use FindBin;
use lib "$FindBin::Bin/../lib";

use Act::Web;
use Plack::Builder;

Act::Web->to_app;
