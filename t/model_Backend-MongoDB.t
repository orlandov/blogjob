use strict;
use warnings;
use Test::More qw(no_plan);
use Data::Dumper;

BEGIN { use_ok 'BlogJob::Model::Backend::MongoDB' }

my $model = BlogJob::Model::Backend::MongoDB->new;
$model->remove_all_posts;
my @posts;

@posts = $model->posts;
is scalar(@posts), 0;

my $post = BlogJob::Model::Backend::MongoDB::Post->new({
    author => "Orlando",
    created => 1234567890,
    markdown => "foo",
    html => "foo",
    tags => [],
});

$model->add_post($post);
@posts = $model->posts;
is scalar(@posts), 1;

0;
