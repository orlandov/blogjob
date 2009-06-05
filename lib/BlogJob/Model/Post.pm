package BlogJob::Model::Post;
use Moose;

BEGIN { extends 'Catalyst::Model::Adaptor' }

__PACKAGE__->config( 
    class => 'BlogJob::Model::Backend::MongoDB::Post',
);

1;
