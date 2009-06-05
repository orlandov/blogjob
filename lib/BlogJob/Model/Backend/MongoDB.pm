package BlogJob::Model::Backend::MongoDB;
use Moose;
use MooseX::Method::Signatures;
use BlogJob::Model::Backend::MongoDB::Post;

BEGIN { extends 'Catalyst::Model::MongoDB' }

method posts_collection {
    my $db  = $self->dbh;
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
