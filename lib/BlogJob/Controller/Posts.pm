package BlogJob::Controller::Posts;
use Moose;
use MongoDB;

BEGIN { extends 'Catalyst::Controller' }

# /posts 
sub base :Chained('/') :PathPart('posts') CaptureArgs(0) {
    my ($self, $c) = @_;

    my $mongo = $c->model('MongoDB');
    my $connection
        = MongoDB::Connection->new(host => 'localhost', port => 27017);
    my $database   = $connection->get_database('blogjob');
    my $collection = $database->get_collection('posts');
    $c->stash->{collection} = $collection;
}

# /posts
sub root :Chained('base') :PathPart('') Args(0) {
    my ($self, $c, @rest) = @_;

    # posting a new post
    if ($c->request->method eq 'POST') {
        my $collection = $c->stash->{collection};
        $collection->insert( {
            author => $c->request->params->{'username'},
            title => $c->request->params->{'title'},
            markdown => $c->request->params->{'content'},
            created => time
        } );
        return $c->response->redirect($c->uri_for('list'));
    }

    $c->response->body('root');
}

# /posts/list
sub list :Chained('base') PathPart('list') Args(0) {
    my ( $self, $c, @rest) = @_;

    my $collection = $c->stash->{collection};
    my $posts_model = $c->model('MongoDB');
    my @data  = $posts_model->posts;
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
