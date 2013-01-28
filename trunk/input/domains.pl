#!/usr/bin/perl

############
#        $Id$
#Description: Select randomly 100000 unique mail domains from domain_list.txt to writing them into domain_list2.txt
#             domain_list2.txt is needed to generate the emails samples used in the database.
#    $Author$ Lionel Aster Mena Garcia
#      $Date$
#  $Revision$
############

open FILE,"domain_list.txt" or die $!;
@fin = <FILE>;
close FILE;

$lines = @fin;

#Generating 
open FILE,">domain_list2.txt" or die $!;
@temp;
for ($i = 1; $i <= 100000; $i++)
{
    $index = rand($lines - 1);
    while (grep( $_ == $index, @temp))
    {
        print "chivato1";
        $index = rand($lines - 1);
    }
    push(@temp, $index);
    print FILE "@fin[$index]";
}

close FILE;