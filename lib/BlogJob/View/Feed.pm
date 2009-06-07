package BlogJob::View::Feed;
use Moose;
use DateTime;
use XML::Atom::SimpleFeed;

BEGIN { extends 'Catalyst::View' }

sub process {
    my ($self, $c) = @_;

    my $feed = XML::Atom::SimpleFeed->new(
        title   => 'blog.2wycked.net',
        link    => 'http://blog.2wycked.net/',
        link    => { rel => 'self', href => 'http://2wycked.net/posts/feed', },
        updated =>
            DateTime->from_epoch(epoch => $c->stash->{posts}->[0]->created),
        author  => 'Orlando Vazquez',
    );

    foreach my $post (@{$c->stash->{posts}}) {
        my @tags;
        if ($post->tags) {
            @tags = @{$post->tags};
        }

        $feed->add_entry(
            title   => $post->title,
            link    => $c->uri_for('/posts'),
            updated => DateTime->from_epoch(epoch=>$post->created)->iso8601,
            content => $post->html,
            author => $post->author
        );
    }

    $c->res->content_type('application/atom+xml');
    $c->res->output($feed->as_string);
}

no Moose;

__PACKAGE__->meta->make_immutable;

1;
