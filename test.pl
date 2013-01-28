#!/usr/local/bin/perl

open (MYFILE, 'domain_list.txt');

@array = <MYFILE>;
($first, $second, $third, $fourth, $fifth) = @array;
chomp $first, $second, $third, $fourth, $fifth;
print "Contents: $second";

 
close (MYFILE);