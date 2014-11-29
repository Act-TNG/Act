package Act::Role::Storage::DBIC;

use Act::Schema;
use Module::Runtime qw( require_module );
use namespace::clean;

use Moo::Role;

has _schema => ( is => 'lazy' );

sub _build__schema {
    Act::Schema->connect(
        @{ shift->config->{endpoint} }{qw( uri user pass )} );
}

has _entity_to_source => (
    is      => 'lazy',
    default => sub { { User => 'User' } },
);

sub _search_rs {
    my ( $self, $entity_name, @args ) = @_;
    my $source_name = $self->_entity_to_source->{$entity_name};
    $self->_schema->resultset($source_name)->search_rs(@args);
}

sub search_raw {
    my ( $self, $entity_name, @args ) = @_;
    require_module("Act::Transformer::$entity_name");
    return $self->_search_rs( $entity_name, @args )->search(
        {},
        { result_class => "Act::Transformer::$entity_name"->new( act => $self ) }
    )->all;
}

1;
