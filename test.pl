#!/usr/bin/perl

use strict;
use warnings;

use GUI::DB qw(dbConnect query);


#Checks a table's existence
#Parameters: Database handler, table name
#Returns: true if it exists, false otherwise
sub tableExists
{
    my $dbh = shift;
    my $table = shift;
    
    my @tables = $dbh->tables('','','','TABLE');
    foreach (@tables) 
    {
        return 1 if ($_ =~ /$table/) 
    }
    # foreach (@tables)
    # {
    #     
    #     print "chivato $table\n";
    #     return 1 if $_ eq $table
    # }
    return 0;
}

#Counts domains ocurrence from the mails table
#Parameters: DBI array of emails 
#Returns: dictionary of domains and its occurrences
sub dailyCount
{
    my ($data) = @_;
    my %elements = ( );

    foreach my $row (@$data)
    {
        my ($f0, $f1) = split(/@/, $row->{addr});
        if (exists($elements{$f1}))
        {
            $elements{$f1}++;
        }
        else
        {
            $elements{$f1} = 1;
        }
        
    }
    return %elements;  
}


my $results_table = "domains_count";

my $dbh = dbConnect();
my $sql;

#creating the results database
if (!tableExists($dbh, $results_table))
{
    $sql = "CREATE TABLE $results_table (
                id INT NOT NULL AUTO_INCREMENT PRIMARY KEY, 
                domain VARCHAR(255) NOT NULL,
                daily_count INT,
                cur_timestamp TIMESTAMP)";
    query($dbh, $sql);
}

#Getting daily mails from the mailing table 
$sql = 'SELECT addr FROM mailing';
my @data = query($dbh, $sql);

#Getting the domains counted
my %domains_count = dailyCount(\@data);

#Sorting the domains by it count
my @domains = sort {$domains_count{$b} <=> $domains_count{$a}} (keys(%domains_count));
foreach my $domain (@domains)
{
   print "[$domain]:\t\t$domains_count{$domain}\n";
}

# while (my ($domain, $ocur) = each(%domains_count))
# {
#    print "[$domain]: $ocur\n";
# }

__END__