package BlogJob;

use Catalyst::Runtime 5.80;
use parent qw/Catalyst/;
use Catalyst qw/-Debug
                ConfigLoader
                Authentication
                Markdown
                Session
                Session::Store::FastMmap
                Session::State::Cookie
                Static::Simple/;
our $VERSION = '0.01';

__PACKAGE__->config(
    name => 'BlogJob',
    session => { flash_to_stash => 1, storage => '/tmp/session'.time }
);

__PACKAGE__->config->{'Model::Posts'} = {
    args => {
        hostname => 'localhost',
        port => 27017,
        dbname => 'blogjob'
    }
};

__PACKAGE__->setup();

1;
