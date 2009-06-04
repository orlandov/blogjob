package BlogJob::Model::Backend::MongoDB;
use Moose;
use MooseX::Method::Signatures;
use BlogJob::Model::Backend::MongoDB::Post;

has 'connection' => (
    isa => 'MongoDB::Connection',
    is => 'rw',
    lazy => 1,
    default => sub {
        MongoDB::Connection->new(host => 'localhost', port => 27017);
    }
);

has 'db' => (
    isa => 'MongoDB::Database',
    is => 'rw',
    lazy => 1,
    builder => '_connect_to_db'
);

method _connect_to_db {
    return $self->connection->get_database('blogjob');
}

BEGIN { extends 'Catalyst::Model' }

method posts_collection {
    my $db  = $self->db;
    return $db->get_collection('posts');
}

method posts {
    my @data = $self->posts_collection->query->all;
    return map {
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

1;
