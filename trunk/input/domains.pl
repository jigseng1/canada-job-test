#!/usr/bin/perl


open FILE,"domain_list.txt" or die $!;
@fin = <FILE>;
close FILE;

$lines = @fin;


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