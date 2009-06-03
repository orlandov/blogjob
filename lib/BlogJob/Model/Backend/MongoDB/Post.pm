package BlogJob::Model::Backend::MongoDB::Post;
use Moose;
use MooseX::Method::Signatures;
use MongoDB;

BEGIN { extends 'Catalyst::Model' }

has [ qw/_id author markdown html title / ]
               => ( isa => 'Str',      is => 'rw', default => '' );
has 'created'  => ( isa => 'Int',      is => 'rw', default => sub { time } );
has 'tags'     => ( isa => 'ArrayRef', is => 'rw' );

method as_hash {
    my $p = { %$self };
    delete $p->{_id} if (!$self->_id);
    return $p;
}

no Moose;

1;
