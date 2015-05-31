package Act::REST::DataStore;

use Moo;

has storage_engine => (
  is => 'ro'
);

# methods that should handle default behaviour
# if not provided by the REST::DataStore subclass

sub insert { };
sub lookup { };
sub update { };
sub remove { };
sub search { };

sub all    { my $prompt = "ALL"; use DDP; p $prompt; return};
sub next   { };

1;
