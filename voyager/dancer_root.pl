#!/usr/bin/env perl

use lib '../lib';

use Dancer2;

use strict;
use warnings;

use Dancer2::Plugin::ResourceRoot;

# get '/:synd/:edtn/news/?'
#     => sub {
#     };
# 
# get '/:synd/news/?'
#     => sub {
#         warn "Get Out!";
#     };

get '/:synd?/:edtn?/news/?' 
    => sub {
        return 'Newer!!!!';
    };

get '/:synd/:edtn/news/:id'
    => sub {
    };
get '/:synd/news/:id'
    => sub {
        warn "Get Out!";
    };
get '/news/:id'
    => sub {
        return 'Newer!!!!';
};

put '/:synd/news/:id'
    => sub {
    };

put '/news/:id'
    => sub {
        return 'Newer!!!!';
};

dance;