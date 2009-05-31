package BlogJob::Controller::Posts;
use Moose;
use MongoDB;

BEGIN { extends 'Catalyst::Controller' }

sub list :Chained('/') PathPart('posts') Args {
    my ( $self, $c, @rest) = @_;

    my $connection = MongoDB::Connection->new(host => 'localhost', port => 27017);
    my $database   = $connection->get_database('foo');
    my $collection = $database->get_collection('bar');
    my $id         = $collection->insert({ some => 'data' });
    my $data       = $collection->find_one({ _id => $id });

    $c->response->body("Matched BlogJob::Controller::Posts in Posts. @rest");
}
1;
