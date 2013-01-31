#!/usr/bin/perl

############
#        $Id$
#Description: Updates the "mailing" table with emails from a file given, optionally can reset the table
#    $Author$ Lionel Aster Mena Garcia
#      $Date$
#  $Revision$
############

use strict;
use warnings;
use GUI::DB qw(dbConnect query);

our $table_name = "mailing";

if ($ARGV[0])
{
    my ($emails_file, $reset) = @ARGV;

    my $dbh = dbConnect();

    #Resetting the table on a fast way
    if ($reset)
    {
        my $sql = "TRUNCATE TABLE $table_name";
        query($dbh, $sql);
    }

    #Getting emails list from the file
    open (MAILF, $emails_file) or die "\nERROR: Cannot open specified file: $!\n";
    my @emails = <MAILF>;
    close MAILF;
    chomp(@emails);

    #Inserting emails through a sole INSERT query
    my $sql = "INSERT INTO $table_name VALUES " . join (', ', ("(?)") x scalar(@emails));
    query($dbh, $sql, @emails);

    $dbh->disconnect;
}
else
{
    print "\nUsage: tableUpdate.pl emails_file [-t]\n";
    exit -1;
}

__END__