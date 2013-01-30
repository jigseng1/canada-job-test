#!/usr/bin/perl

############
#        $Id$
#Description: Updates the "mailing" table with a mysql bacth given
#    $Author$ Lionel Aster Mena Garcia
#      $Date$
#  $Revision$
############

use strict;
use warnings;
use GUI::DB qw(dbConnect query);

if ($ARGV[0])
{
    my $batch_file = shift;

    my $table_name = "mailgen";

    my $dbh = dbConnect();

    #Deleting in a fast way the previous content
    my $sql = "TRUNCATE TABLE mailing";
    query($dbh, $sql);

    #Passing to mysql the batch batch_file
    exec "mysql -u layo < $batch_file"
}
else
{
    print "\nUsage: tableUpdate.pl mysql_batch\n";
    exit -1;
}

__END__