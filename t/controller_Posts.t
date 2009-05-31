use strict;
use warnings;
use Test::More tests => 3;

BEGIN { use_ok 'Catalyst::Test', 'BlogJob' }
BEGIN { use_ok 'BlogJob::Controller::Posts' }

ok( request('/posts')->is_success, 'Request should succeed' );


