package BlogJob::Model::Backend::MongoDB::Post;

use Moose;
use MooseX::Method::Signatures;
use Moose::Util::TypeConstraints;

use MongoDB;
use MongoDB::OID;

BEGIN { extends 'Catalyst::Model' }

has 'id' => (
    isa => 'Str',
    is => 'rw',
    default => '',
    coerce => 1
);

subtype 'Mongo::OID' => as class_type('MongoDB::OID');

coerce 'Str'
    => from 'MongoDB::OID'
    => via { $_->{_id}{value} };

has [ qw( author markdown html title ) ]
               => ( isa => 'Str',      is => 'rw', default => '' );
has 'created'  => ( isa => 'Int',      is => 'rw', default => 0 );
has 'tags'     => ( isa => 'ArrayRef', is => 'rw' );

method as_hash {
    my $p = { %$self };
    delete $p->{_id} if (!$self->_id);
    return $p;
}

no Moose;

1;
