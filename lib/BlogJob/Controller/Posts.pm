package BlogJob::Controller::Posts;
use Moose;
use MongoDB;

BEGIN { extends 'Catalyst::Controller' }

sub base :Chained('/') :PathPart('posts') CaptureArgs(0) {}

sub root :Chained('base') :PathPart('') Args(0) {
    my ($self, $c, @rest) = @_;

    # posting a new post
    if ($c->request->method eq 'POST') {
        my $connection
            = MongoDB::Connection->new(host => 'localhost', port => 27017);
        my $database   = $connection->get_database('blogjob');
        my $collection = $database->get_collection('posts');

        $collection->insert( {
            username => $c->request->params->{'username'},
            title => $c->request->params->{'title'},
            content => $c->request->params->{'content'},
        } );
        return $c->response->redirect($c->uri_for('list'));
    }

    $c->response->body('root');
    
}

sub list :Chained('base') PathPart('list') Args(0) {
    my ( $self, $c, @rest) = @_;

    my $connection = MongoDB::Connection->new(host => 'localhost', port => 27017);
    my $database   = $connection->get_database('blogjob');
    my $collection = $database->get_collection('posts');
    #my $id         = $collection->insert({ some => 'data' });
    my @data       = $collection->query->all;
    $c->stash->{posts} = \@data;
    $c->stash->{template} = "posts/list.tt2";
}

sub create :Chained('base') PathPart('create') Args(0) {
    my ($self, $c) = @_;

    $c->stash->{template} = "posts/create.tt2";
}
1;
