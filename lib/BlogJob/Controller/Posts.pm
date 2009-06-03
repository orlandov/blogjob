package BlogJob::Controller::Posts;
use Moose;
use MongoDB;

BEGIN { extends 'Catalyst::Controller' }

# /posts 
sub base :Chained('/') :PathPart('posts') CaptureArgs(0) {
    my ($self, $c) = @_;
    $c->stash->{posts_model} = $c->model('MongoDB');
}

# /posts
sub root :Chained('base') :PathPart('') Args(0) {
    my ($self, $c, @rest) = @_;

    # posting a new post
    if ($c->request->method eq 'POST') {
        my $post = BlogJob::Model::Backend::MongoDB::Post->new({
            author => $c->request->params->{'username'},
            title => $c->request->params->{'title'},
            markdown => $c->request->params->{'content'},
            created => time
        });
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
