package Act::REST::api;

use Moo;
use MooX::Types::MooseLike::Base 'HashRef';

use Class::Load 'load_class';

use constant PACKAGE_DATASTORE => 'Act::REST::DataStore';
use constant PACKAGE_OBJECT    => 'Act::REST::Object';

load_class(PACKAGE_DATASTORE);
load_class(PACKAGE_OBJECT);

use Act::Config;
use Act::Schema;

our $ActSchema = Act::Schema->connect(
    $Config->database_dsn,
    $Config->database_user,
    $Config->database_passwd,
    undef
);

has storage_engine => (
    is      => 'ro',
    default => sub {
        return $ActSchema;
    },
);

has class_datastore => (
    is      => 'rw',
    isa     => HashRef,
    default => sub { return { } },
);

sub datastore {
    my $self = shift;
    my $name = shift;
    unless (exists $self->class_datastore->{$name}) {
        my $class_name = PACKAGE_DATASTORE . "::" . $name;
        load_class($class_name);
        $self->class_datastore->{$name} = $class_name
            ->new(storage_engine => $self->storage_engine);
    };
    return $self->class_datastore->{$name};
};

has class_object => (
    is      => 'rw',
    isa     => HashRef,
    default => sub { return { } },
);

sub object {
    my $self = shift;
    my $name = shift;
    unless (exists $self->class_object->{$name}) {
        my $class_name = PACKAGE_OBJECT . "::" . $name;
        load_class($class_name);
        $self->class_object->{$name} = $class_name
            ->new(storage_engine => $self->storage_engine);
    };
    return $self->class_object->{$name};
};

1;

