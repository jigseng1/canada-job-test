#!/usr/bin/perl

############
#        $Id$
#Description: Generates SQL batch files with the specified number of generated emails.
#    $Author$ Lionel Aster Mena Garcia
#      $Date$
#  $Revision$
############

use strict;
use warnings;

#Generates randoms email names (without a domain)
#Parameters: max lenght of the name
#Returns: the email name generated
sub mailGenerator
{
    my @chars=('a'..'z', '0'..'9','_');
    my $email_name;

    #Setting the random doman lenght between 4 - 15
    my $len = int(rand($_[0])) + 4;
    # rand @chars will generate a random 
    # number between 0 and scalar @chars
    foreach (1..$len)
    {
        $email_name .= $chars[rand @chars];
    }
    return $email_name;
}

#Return a random selected mail domain from a given file
#Parameters: mail domains file
#Returns: the domain selected
sub getDomain
{
    open (FILE, "<", $_[0]) or die "\nERROR: Cannot open the domains file: $!\n";
    my @fin = <FILE>;
    my $nlines = @fin;
    close FILE;

    my $domain = @fin[rand($nlines - 1)];
    chomp $domain;
    return $domain;
}

my $domains_file = 'domain_list2.txt';

if ($ARGV[1])
{
    my $fout = $ARGV[0];
    my $n_emails = $ARGV[1];
    open (MAILF, ">", $fout) or die "\nERROR: Cannot Open the file specified: $!\n";

    print MAILF "USE test;\n\n";

    foreach (0..$ARGV[1])
    {
        my $email = &mailGenerator(12) . "@" . &getDomain($domains_file);
        print MAILF "INSERT INTO mailing VALUES('$email');\n";
    }
    close MAILF;
} 
else
{
    print "\nUsage: mailgen.pl output_file emails_number\n";
    exit -1;
}
