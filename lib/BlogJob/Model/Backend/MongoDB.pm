package BlogJob::Model::Backend::MongoDB;
use Moose;
use MooseX::Method::Signatures;
use BlogJob::Model::Backend::MongoDB::Post;

BEGIN { extends 'Catalyst::Model' }

has hostname => ( isa => 'Str', is => 'ro' );
has port     => ( isa => 'Int', is => 'ro' );
has dbname   => ( isa => 'Str', is => 'ro' );

has 'connection' => (
    isa => 'MongoDB::Connection',
    is => 'rw',
    lazy_build => 1
);

has 'db' => (
    isa => 'MongoDB::Database',
    is => 'rw',
    lazy_build => 1,
);

method _build_connection {
    return MongoDB::Connection->new(
        host => $self->hostname,
        port => $self->port,
    );
}

method _build_db {
    return $self->connection->get_database('blogjob');
}

method posts_collection {
    my $db  = $self->db;
    return $db->get_collection('posts');
}

method posts {
    my @data = $self->posts_collection->query->all;
    return
        sort  {
            $b->created <=> $a->created
        }
        map {
            BlogJob::Model::Backend::MongoDB::Post->new($_)
        } @data;
}

method add_post(BlogJob::Model::Backend::MongoDB::Post $post) {
    $self->posts_collection->insert($post->as_hash);
}

method remove_all_posts {
    $self->posts_collection->remove({});
}

no Moose;

__PACKAGE__->meta->make_immutable;

1;
