package Act::Web;
use Dancer2;
use Act::Web::Event;

our $VERSION = '0.001';

get '/' => sub {
    template 'index';
};

1;
