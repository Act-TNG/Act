package Plack::Middleware::Act::ResourceRoot;

use parent 'Plack::Middleware';

use Act::Config;
use Act::Schema;

our $ActSchema = Act::Schema->connect(
    $Config->database_dsn,
    $Config->database_user,
    $Config->database_passwd,
    undef
);

sub call {
    my $self = shift;
    my $rqst = shift;
    my $resp = undef;
    
    my $chck = undef;
    
    #
    # is there a list of events for this syndicate
    #
    
    $chck = exists $rqst->{HTTP_X_ACT_SYNDICATE}
    ? $rqst->{HTTP_X_ACT_SYNDICATE}
    : ($rqst->{PATH_INFO} =~ /^\/([-\w]+).*/)[0]; # first element of path
    
    my @list = $ActSchema->resultset('Conference')
        ->search( {syndicate => $chck} )->all;
    if ( !@list and exists $rqst->{HTTP_X_ACT_SYNDICATE} ) {
        return [400, [], []]; # X-Header has bad ID for Syndicate
    }
    if ( !@list ) {
        goto RESPONSE unless exists $rqst->{HTTP_X_ACT_EDITION};
        return [400, [], []]; # If not Syndicate, DONT provide X-Header
    }    
    $rqst->{HTTP_X_ACT_SYNDICATE} = $chck;
    $rqst->{PATH_INFO} =~ s/^\/[-\w]+//; # chop off first element
    
    #
    # does any of the found events match this the edition
    #
    
    $chck = exists $rqst->{HTTP_X_ACT_EDITION}
    ? $rqst->{HTTP_X_ACT_EDITION}
    : ($rqst->{PATH_INFO} =~ /^\/([-\w]+).*/)[0]; # again first element
    
    my $evnt = ( grep {$_->edition eq $chck} @list )[0];
    if ( !$evnt and exists $rqst->{HTTP_X_ACT_EDITION} ) {
        return [400, [], []]; # X-Header has bad ID for Edition
    }
    if ( !$evnt ) {
        goto RESPONSE;
    }    
    $rqst->{HTTP_X_ACT_EDITION} = $chck;
    $rqst->{PATH_INFO} =~ s/^\/[-\w]+//; # chop off first element
    
    #
    # apparently, we have a full qualified event path
    #
    
    $rqst->{HTTP_X_ACT_CONFERENCE} = $evnt->conf_id; # no need to lookup again
    
    RESPONSE:
    my $resp = $self->app->($rqst);    
    Plack::Util::response_cb(
        $resp => sub {
            my $resp = shift;
            return;
        });
    
    return $resp;
}

1;