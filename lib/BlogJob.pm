package BlogJob;

use strict;
use warnings;

use Catalyst::Runtime 5.80;

# Set flags and add plugins for the application
#
#         -Debug: activates the debug mode for very useful log messages
#   ConfigLoader: will load the configuration from a Config::General file in the
#                 application's home directory
# Static::Simple: will serve static files from the application's root
#                 directory

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

# Configure the application.
#
# Note that settings in blogjob.conf (or other external
# configuration file that you set up manually) take precedence
# over this when using ConfigLoader. Thus configuration
# details given here can function as a default configuration,
# with an external configuration file acting as an override for
# local deployment.

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

__PACKAGE__->config->{'Plugin::Authentication'} = {
    use_session => 1,
    default => {
        credential => {
            class => 'Password',
            password_field => 'password',
            password_type => 'clear'
        },
        store => {
            class => 'Minimal',
            users => {
                orlando => {
                    name => 'Orladno Vazquez',
                    password => 'secret',
                    roles => [qw/edit delete create comment/]
                }
            }
        }
    }

};

# Start the application
__PACKAGE__->setup();


=head1 NAME

BlogJob - Catalyst based application

=head1 SYNOPSIS

    script/blogjob_server.pl

=head1 DESCRIPTION

[enter your description here]

=head1 SEE ALSO

L<BlogJob::Controller::Root>, L<Catalyst>

=head1 AUTHOR

Orlando Vazquez,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
