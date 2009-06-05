package Catalyst::Model::MongoDB;
use Moose;

BEGIN { extends 'Catalyst::Model' }

has hostname => ( isa => 'Str', is => 'ro' );
has port     => ( isa => 'Int', is => 'ro' );
has dbname   => ( isa => 'Str', is => 'ro' );

has 'connection' => (
    isa => 'MongoDB::Connection',
    is => 'rw',
    lazy_build => 1
);

has 'dbh' => (
    isa => 'MongoDB::Database',
    is => 'rw',
    lazy_build => 1,
);

sub _build_connection {
    my ($self) = @_;
    return MongoDB::Connection->new(
        host => $self->hostname,
        port => $self->port,
    );
}

sub _build_dbh {
    my ($self) = @_;
    return $self->connection->get_database($self->dbname);
}

no Moose;

__PACKAGE__->meta->make_immutable;

1;
