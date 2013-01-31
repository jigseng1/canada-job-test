#!/usr/bin/perl

############
#        $Id$
#Description: Creates a file with the specified number of generated emails.
#    $Author$ Lionel Aster Mena Garcia
#      $Date$
#  $Revision$
############

use strict;
use warnings;

use File::RandomLine;
use String::Random;

my $domains_file = 'domain_list2.txt';

if ($ARGV[1])
{
    my $fout = $ARGV[0];
    my $n_emails = $ARGV[1];
    open (MAILF, ">", $fout) or die "\nERROR: Cannot open specified file: $!\n";

    # Set algorithm => "uniform" if uniformness through file is desired
    # It may penalize performance significantly on large files
    my $rnd_domain = File::RandomLine->new($domains_file, {algorithm => "fast"});
    foreach (1..$ARGV[1])
    {
        my $rnd_mail = new String::Random;
        # User string will always start with a letter, followed by 3 to 10 alphanumeric + '_' chars
        my $email = $rnd_mail->randregex('[a-z]{1}[a-z0-9_]{3,10}') . "@" . $rnd_domain->next;
        
        print MAILF "$email\n";
    }
    close MAILF;
} 
else
{
    print "\nUsage: mailgen.pl output_file emails_number\n";
    exit -1;
}

__END__