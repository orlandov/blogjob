package BlogJob::Controller::Auth;
use Moose;

BEGIN { extends 'Catalyst::Controller' }

sub login_old : Local {
    my ($self, $c) = @_;
   
    if ($c->request->method =~ /get/i) {
        if ($c->user) {
            # user is already logged in
            return $c->response->redirect($c->uri_for('/posts/list'));
        }
        $c->stash->{template} = 'login/form.tt2';
        return;
    }

    if (     my $username = $c->request->param("username")
         and my $password = $c->request->param("password") ) {
        if ($c->authenticate({ username => $username,
                               password => $password })) {
             $c->response->redirect($c->uri_for('/posts/list'));
             return;
        }
        else {
           $c->flash->{error} = 'Wrong username or password';
           $c->response->redirect($c->uri_for('login'));
           return;
        }
    }
    else {
        $c->flash->{error} = 'Missing credentials';
        $c->response->redirect($c->uri_for('login'));
        return;
    }
}

sub openid : Local {
    my ($self, $c) = @_;
    if (my $userobj=$c->authenticate) {
        $c->flash->{'success'}='OpenID login successful';    
        $c->res->redirect($c->uri_for('/auth/user'));
        return;
    }
    else {
        $c->stash->{template} = 'login/openid.tt2';
        return;
    }
}

sub user : Local {
    my ($self, $c) = @_;
    use Data::Dumper;
    $c->res->body(Dumper $c->user);
}

sub logout : Local {
    my ($self, $c) = @_;

    if ($c->user) {
        $c->logout;
        $c->flash->{message} = 'You successfully logged out. See you next time.';
    }

    return $c->response->redirect($c->uri_for('/posts/list'));
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
