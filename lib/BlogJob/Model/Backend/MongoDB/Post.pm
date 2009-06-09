package BlogJob::Model::Backend::MongoDB::Post;

use Moose;
use MooseX::Method::Signatures;
use Moose::Util::TypeConstraints;

use MongoDB;
use MongoDB::OID;

BEGIN { extends 'Catalyst::Model' }

has '_id' => (
    isa => 'Item', # use Item because this may be undef
    is => 'rw',
    default => '',
    coerce => 1,
    required => 0,
);

subtype 'Mongo::OID' => as class_type('MongoDB::OID');

coerce 'Str'
    => from 'MongoDB::OID'
    => via { $_->{_id}{value} };

has [ qw( author canonical_name summary markdown html title ) ]
               => ( isa => 'Str',      is => 'rw', default => '' );
has 'created'  => ( isa => 'Int',      is => 'rw', default => 0 );
has 'tags'     => ( isa => 'ArrayRef', is => 'rw', default => sub { [] });

method as_hash {
    my $p = { %$self };
    if ($self->_id && ref ($self->_id) eq 'MongoDB::OID') {
        $p->{_id} = $self->_id->value;
    }
    else {
        delete $p->{_id} if (!$self->_id);
    }
    return $p;
}

no Moose;

1;
