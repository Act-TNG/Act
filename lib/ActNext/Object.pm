package Act::Next;

use Moo;
use MooX::Types::MooseLike::Base 'HashRef';

use Class::Load 'load_class';

use constant PACKAGE_DATASTORE  => 'Act::Next::DataStore';
use constant PACKAGE_OBJECT     => 'Act::Next::Object';
use constant PACKAGE_SET        => 'Act::Next::Set';

load_class(PACKAGE_DATASTORE);
load_class(PACKAGE_OBJECT);
load_class(PACKAGE_SET);

use Act::Config;
use Act::Schema;

our $ActSchema = Act::Schema->connect(
    $Config->database_dsn,
    $Config->database_user,
    $Config->database_passwd,
    undef
);

has default_languages => (
  is      => 'rw',
);

has storage_engine => (
    is      => 'ro',
    default => sub {
        return $ActSchema;
    },
);

has class_resource_datastore => (
    is      => 'rw',
    isa     => HashRef,
    default => sub { return { } },
);

sub resource {
    my $self = shift;
    my $name = shift;
    unless (exists $self->class_resource_datastore->{$name}) {
        my $class_name = PACKAGE_DATASTORE . "::" . $name;
        load_class($class_name);
        $self->class_resource_datastore->{$name} = $class_name
            ->new({
                storage_engine    => $self->storage_engine,
                default_languages => $self->default_languages,
            });
    };
    return $self->class_resource_datastore->{$name};
};

has class_resource_object => (
    is      => 'rw',
    isa     => HashRef,
    default => sub { return { } },
);

sub object {
    my $self = shift;
    my $name = shift;
    unless (exists $self->class_resource_object->{$name}) {
        my $class_name = PACKAGE_OBJECT . "::" . $name;
        load_class($class_name);
        $self->class_resource_object->{$name} = $class_name
            ->new({
                storage_engine    => $self->storage_engine,
                default_languages => $self->default_languages,
            });
    };
    return $self->class_resource_object->{$name};
};

has class_resource_set => (
    is      => 'rw',
    isa     => HashRef,
    default => sub { return { } },
);

sub set {
    my $self = shift;
    my $name = shift;
    unless (exists $self->class_resource_set->{$name}) {
        my $class_name = PACKAGE_SET . "::" . $name;
        load_class($class_name);
        $self->class_resource_set->{$name} = $class_name
            ->new(storage_engine => $self->storage_engine);
    };
    return $self->class_resource_set->{$name};
};

1;

