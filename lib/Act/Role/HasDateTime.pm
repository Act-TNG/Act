package Act::Role::HasDateTime;

use Moo::Role;
use DateTime;

sub BUILDARGS {
    my $class = shift;
    my %args  = @_ == 1 ? %{ $_[0] } : @_;

    # XXX can be removed when DBIC returns timestamp instead
    if ( defined $args{'datetime'} ) {
        my $regexp = qr{
            ^
            (\d{4})-(\d{2})-(\d{2})
            \s
            (\d{2}):(\d{2}):(\d{2})
            $
        }x;

        my ( $year, $month, $day, $hour, $minute, $second ) =
            $args{'datetime'} =~ $regexp;

        $args{'datetime'} = DateTime->new(
            year => $year, month  => $month,  day    => $day,
            hour => $hour, minute => $minute, second => $second,
        );
    }

    return \%args;
}

1;

