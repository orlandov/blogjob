use strict;
use warnings;
use Test::More tests => 3;

BEGIN { use_ok 'Catalyst::Test', 'BlogJob' }
BEGIN { use_ok 'BlogJob::Controller::Auth' }

ok( request('/auth')->is_success, 'Request should succeed' );


