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
    my ($query) = @_;
    my @data = $self->posts_collection->query($query)->all;
    return
        sort { $b->created <=> $a->created }
        map  {
            BlogJob::Model::Backend::MongoDB::Post->new($_)
        } @data;
}

method by_canonical($name) {
    return $self->posts(
        { canonical_name => $name }
    );
}

method remove($query) {
    $self->posts_collection->remove($query);
}

method add(BlogJob::Model::Backend::MongoDB::Post $post, :$query) {
    $self->posts_collection->insert($post->as_hash);
}

method update(BlogJob::Model::Backend::MongoDB::Post $post, :$canonical_name) {
    $self->posts_collection->update(
        { canonical_name => $canonical_name },
        $post->as_hash
    );
}

method remove_all {
    $self->posts_collection->remove({});
}

no Moose;

__PACKAGE__->meta->make_immutable;

1;
