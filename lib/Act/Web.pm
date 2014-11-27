package Act::Web;
use Dancer2;

our $VERSION = '0.001';

get '/' => sub {
    template 'index';
};

1;
