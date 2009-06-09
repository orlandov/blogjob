package BlogJob::Controller::Posts;
use Moose;

BEGIN { extends 'Catalyst::Controller' }

# /posts 
sub base :Chained('/') :PathPart('posts') CaptureArgs(0) {
    my ($self, $c) = @_;
    $c->stash->{posts_model} = $c->model('Posts');
}

# /posts
sub root :Chained('base') :PathPart('') Args(0) {
    my ($self, $c, @rest) = @_;

    if ($c->req->method eq 'POST') {
        if (! $c->user) {
            $c->flash->{message} = 'You have to be logged in to create posts';
            $c->res->redirect($c->uri_for('list'));
            return;
        }
        my $post = $c->model('Post');

        my $tags = $c->req->params->{'tags'};
        $tags =~ s/^\s+//g;
        $tags =~ s/\s+$//g;
        $post->tags([ split /,/, $tags ]);

        my $created = time;
        my $dt = DateTime->from_epoch(epoch => $created);

        my ($title, $canonical_title); 
        $title = $canonical_title = $c->req->params->{'title'};
        $post->created($created);
        $canonical_title =~ s/^\s+//g;
        $canonical_title =~ s/\s+$//g;
        $canonical_title =~ s/\s+/-/g;
        $canonical_title =~ s/[^-\w]+//g;
        my $canonical_name
            = join '/', ($dt->year, $dt->month, $canonical_title);

        warn $canonical_title;
        $post->canonical_name($canonical_name);
        $post->author($c->user->id);
        $post->summary($c->req->params->{'summary'});
        $post->title($title);
        $post->markdown($c->req->params->{'content'});
        $post->html(
            $c->markdown->markdown($c->req->params->{content}));
        $c->stash->{posts_model}->add_post($post);

        return $c->res->redirect($c->uri_for('list'));
    }

    $c->forward('list');
}

sub _post_from_params {
    my ($self, $post, $c, %args) = @_;

    my $tags = $args{'tags'};
    $tags =~ s/^\s+//g;
    $tags =~ s/\s+$//g;
    $post->tags([ split /,/, $tags ]);

    my $created = $args{'created'}; # bug
    my $dt = DateTime->from_epoch(epoch => $created);

    my ($title, $canonical_title); 
    $title = $canonical_title = $args{title};
    $post->created($created);
    $canonical_title =~ s/^\s+//g;
    $canonical_title =~ s/\s+$//g;
    $canonical_title =~ s/\s+/-/g;
    $canonical_title =~ s/[^-\w]+//g;
    my $canonical_name
        = join '/', ($dt->year, $dt->month, $canonical_title);

    warn $canonical_title;
    $post->canonical_name($canonical_name);
    $post->author($args{author});
    $post->summary($args{'summary'});
    $post->title($title);
    $post->markdown($args{'content'});
    $post->html(
        $c->markdown->markdown($args{content}));

    return $post;
}

# /posts/yyyy/mm/title-title
sub view :Chained('base') PathPart('view') Args {
    my ($self, $c, @name) = @_;

    my @data = $c->stash->{posts_model}->posts(
        query => {
            canonical_name => join( '/', @name)
        }
    );
    $c->stash->{posts} = \@data;
    $c->stash->{template} = "posts/list.tt2";
}

# /posts/list
sub list :Chained('base') PathPart('list') Args(0) {
    my ( $self, $c, @rest) = @_;
    my @data = $c->stash->{posts_model}->posts;
    $c->stash->{posts} = \@data;
    $c->stash->{template} = "posts/list.tt2";
}

# /posts/feed
sub feed :Chained('base') PathPart('feed') Args(0) {
    my ($self, $c) = @_;
    my @data = $c->stash->{posts_model}->posts;
    $c->stash->{posts} = \@data;
    $c->forward('BlogJob::View::Feed');
}

# /posts/create
sub create :Chained('base') PathPart('create') Args(0) {
    my ($self, $c) = @_;
    if (! $c->user) {
        $c->flash->{message} = 'You are not logged in to create posts';
        $c->response->redirect($c->uri_for('list'));
        return;
    }
    $c->stash->{template} = "posts/create.tt2";
}

# /posts/edit/2009/06/foo-bar-baz
sub edit :Chained('base') PathPart('edit') Args {
    my ($self, $c, @name) = @_;
    if (! $c->user) {
        $c->flash->{error} = 'You must be signed in to edit posts';
        $c->response->redirect($c->uri_for('list'));
        return;
    }

    # if GET display form
    if ($c->req->method eq 'GET') {
        my $post = [$c->stash->{posts_model}->posts(
            query => { canonical_name => join('/', @name) }
        )]->[0];
        $c->stash->{post} = $post;
        return $c->stash->{template} = 'posts/edit.tt2';
    }
    elsif ($c->req->method eq 'POST') {
        my $old_canonical = join('/', @name);
        my $post = [$c->stash->{posts_model}->posts(
            query => { canonical_name => $old_canonical }
        )]->[0];

        # this code is so fucking gross
        $self->_post_from_params(
            $post,
            $c,
            created => time,
            author => $c->user->id,
            map { ($_ => $c->req->params->{$_}) }
                qw(markdown tags title summary content)
        );
        $c->stash->{posts_model}->update_post($post,
            canonical_name => $old_canonical);
        $c->flash->{success} = 'Post successfully saved';
        return $c->res->redirect($c->uri_for('list'));
    }
}

# /posts/delete
sub delete :Chained('base') PathPart('delete') Args {
    my ($self, $c, @name) = @_;
    if (! $c->user) {
        $c->flash->{error} = 'You must be signed in to delete posts';
        $c->response->redirect($c->uri_for('list'));
        return;
    }

    my ($canonical_name) = join('/', @name) ;
    $c->flash->{success} = 'Post successfully deleted';
    $c->stash->{posts_model}->remove({ canonical_name =>$canonical_name});
    $c->response->redirect($c->uri_for('list'));
}

no Moose;

__PACKAGE__->meta->make_immutable;

1;
