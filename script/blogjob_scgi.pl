#!/usr/bin/env perl

BEGIN { $ENV{CATALYST_ENGINE} ||= 'SCGI' }

use strict;
use warnings;
use Getopt::Long;
use Pod::Usage;
use FindBin;
use lib "$FindBin::Bin/../lib";
use BlogJob;

my $help = 0;
my ( $port, $detach );
 
GetOptions(
    'help|?'      => \$help,
    'port|p=s'  => \$port,
    'daemon|d'    => \$detach,
);

pod2usage(1) if $help;

BlogJob->run( 
    $port, 
    $detach,
);

1;

=head1 NAME

BlogJob_scgi.pl - Catalyst SCGI

=head1 SYNOPSIS

BlogJob_scgi.pl [options]
 
 Options:
   -? -help     display this help and exits
   -p -port    	Port to listen on
   -d -daemon   daemonize

=head1 DESCRIPTION

Run a Catalyst application as SCGI.

=head1 AUTHOR

Victor Igumnov, C<victori@cpan.org>

=head1 COPYRIGHT

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
