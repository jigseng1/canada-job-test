#!/usr/bin/perl

############
#        $Id$
#Description: Select randomly a specified number of unique mail domains from domain_list.txt to writing them into domain_list2.txt
#             domain_list2.txt is needed to generate the emails samples used in the database.
#    $Author$ Lionel Aster Mena Garcia
#      $Date$
#  $Revision$
############

if ($ARGV[2])
{
    my $fin = $ARGV[0];
    my $fout = $ARGV[1];
    my $domains_number = $ARGV[2];

    open FILE, $fin or die $!;
    @domain_input = <FILE>;
    close FILE;

    $lines = @domain_input;

    #Generating 
    open(FILE, ">", $fout) or die $!;
    my @temp;
    for ($i = 1; $i <= $domains_number; $i++)
    {
        $index = rand($lines - 1);
        while (grep( $_ == $index, @temp))
        {
            $index = rand($lines - 1);
        }
        push(@temp, $index);
        print FILE "@domain_input[$index]";
        #print "chivato $i\n";
    }

    close FILE;
}
else
{
    print "\nUsage: domain_input.txt domain_output.txt domains_number\n";
    exit -1;
}

__END__