package BlogJob::Controller::Posts;
use Moose;

BEGIN { extends 'Catalyst::Controller' }

# /posts 
sub base :Chained('/') :PathPart('posts') CaptureArgs(0) {
    my ($self, $c) = @_;
    $c->stash->{posts_model} = $c->model('Posts');
}

# /posts
sub root :Chained('base') :PathPart('') Args(0) {
    my ($self, $c, @rest) = @_;

    if ($c->request->method eq 'POST') {
        my $post = $c->model('Post');
        $post->author($c->request->params->{'username'});
        $post->title($c->request->params->{'title'});
        $post->markdown($c->request->params->{'content'});
        $post->created(time);
        $c->stash->{posts_model}->add_post($post);

        return $c->response->redirect($c->uri_for('list'));
    }

    $c->forward('list');
}

# /posts/list
sub list :Chained('base') PathPart('list') Args(0) {
    my ( $self, $c, @rest) = @_;
    my @data = $c->stash->{posts_model}->posts;
    $c->stash->{posts} = \@data;
    $c->stash->{template} = "posts/list.tt2";
}

# /posts/create
sub create :Chained('base') PathPart('create') Args(0) {
    my ($self, $c) = @_;
    $c->stash->{template} = "posts/create.tt2";
}

no Moose;
1;
