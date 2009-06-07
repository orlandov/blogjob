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

    if ($c->req->method eq 'POST') {
        if (! $c->user) {
            $c->flash->{message} = 'You have to be logged in to create posts';
            $c->res->redirect($c->uri_for('list'));
            return;
        }
        my $post = $c->model('Post');

        my $tags = $c->req->params->{'tags'};
        $tags =~ s/^\s+//g;
        $tags =~ s/\s+$//g;
        $post->tags([ split /,/, $tags ]);

        $post->author($c->user->id);
        $post->summary($c->req->params->{'summary'});
        $post->title($c->req->params->{'title'});
        $post->markdown($c->req->params->{'content'});
        $post->html(
            $c->markdown->markdown($c->req->params->{content}));
        $post->created(time);
        $c->stash->{posts_model}->add_post($post);

        return $c->res->redirect($c->uri_for('list'));
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

# /posts/feed
sub feed :Chained('base') PathPart('feed') Args(0) {
    my ($self, $c) = @_;
    my @data = $c->stash->{posts_model}->posts;
    $c->stash->{posts} = \@data;
    $c->forward('BlogJob::View::Feed');
}

# /posts/create
sub create :Chained('base') PathPart('create') Args(0) {
    my ($self, $c) = @_;
    if (! $c->user) {
        $c->flash->{message} = 'You are not logged in to create posts';
        $c->response->redirect($c->uri_for('list'));
        return;
    }
    $c->stash->{template} = "posts/create.tt2";
}

no Moose;
1;
