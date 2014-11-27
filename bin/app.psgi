#!/usr/bin/env perl

use FindBin;
use lib "$FindBin::Bin/../lib";

use Act::Web;
Act::Web->to_app;
