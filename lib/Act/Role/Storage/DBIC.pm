package Act::Role::Storage::DBIC;

use Act::Schema;
use namespace::clean;

use Moo::Role;

has _schema => ( is => 'lazy' );

has _entity_to_source => (
    is      => 'ro',
    default => { User => 'User', },
);

sub _build__schema {
    Act::Schema->connect( @{ shift->config }{qw( uri user pass )} );
}

sub _search_rs {
    my ( $self, $entity_name, @args ) = @_;
    my $source_name = $self->_entity_to_source->{$entity_name};
    $self->_schema->resultset($source_name)->search_rs(@args);
}

sub search_raw {
    my ( $self, $entity_name, @args ) = @_;
    return $self->_search_rs( $entity_name, @args )->search(
        {},
        { result_class => "Act::Transformer::$entity_name"->new( $self->act ) }
    )->all;
}

1;
