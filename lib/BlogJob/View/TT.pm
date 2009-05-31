package BlogJob::View::TT;

use strict;
use base 'Catalyst::View::TT';

__PACKAGE__->config({
    INCLUDE_PATH => [
        BlogJob->path_to( 'root', 'src' ),
        BlogJob->path_to( 'root', 'lib' )
    ],
    PRE_PROCESS  => 'config/main',
    WRAPPER      => 'site/wrapper',
    ERROR        => 'error.tt2',
    TIMER        => 0
});

=head1 NAME

BlogJob::View::TT - Catalyst TTSite View

=head1 SYNOPSIS

See L<BlogJob>

=head1 DESCRIPTION

Catalyst TTSite View.

=head1 AUTHOR

Orlando Vazquez

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;

