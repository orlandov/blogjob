package BlogJob::Model::MongoDB;
use Moose;

BEGIN { extends 'Catalyst::Model::Adaptor' }

__PACKAGE__->config( 
    class       => 'BlogJob::Model::Backend::MongoDB',
);

1;
