package BlogJob::Controller::Auth;
use Moose;

BEGIN { extends 'Catalyst::Controller' }

sub login : Local {
    my ($self, $c) = @_;
   
    if ($c->request->method =~ /get/i) {
        if ($c->user) {
            # user is already logged in
            return $c->response->redirect('/posts/list');
        }
        $c->stash->{template} = 'login/form.tt2';
        return;
    }

    if (     my $username = $c->request->param("username")
         and my $password = $c->request->param("password") ) {
        if ($c->authenticate({ username => $username,
                               password => $password })) {
             $c->response->redirect('/posts/list');
             return;
        }
        else {
           $c->response->body("invalid creds jack");
             return;
        }
    }
    else {
        $c->response->body("papers please");
        return;
    }
}

sub logout : Local {
    my ($self, $c) = @_;

    if ($c->user) {
        $c->logout;
        $c->flash->{message} = 'You successfully logged out. See you next time.';
    }

    return $c->response->redirect('/posts/list');
}

1;
