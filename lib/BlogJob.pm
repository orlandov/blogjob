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

__PACKAGE__->setup();

1;
