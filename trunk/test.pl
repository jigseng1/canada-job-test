#!/usr/bin/perl

use strict;
use warnings;

use GUI::DB qw(dbConnect query);

our $emails_table = "mailing";
our $results_table = "domains_count";

#
#Checks a table's existence
#Parameters: Database handler, table name
#Returns: true if it exists, false otherwise
#
sub tableExists
{
    my $dbh = shift;
    my $table = shift;
    
    my @tables = $dbh->tables('','','','TABLE');
    foreach (@tables) 
    {
        return 1 if ($_ =~ /$table/) 
    }
    return 0;
}

#
#Counts domains ocurrence from the mails table
#Parameters: reference to a DBI array of emails 
#Returns: hash of domains and its occurrences
#
sub dailyCount
{
    my ($data) = shift;
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

#
#Update de table $results_table with the daily domain's counting
#Parameters: Database handler, reference to the hash of domain's counting
#Returns: nothing
#
sub updateDomainCount
{
    my $dbh = shift;
    my ($data) = shift;

    my $sql = "INSERT INTO $main::results_table (domain, daily_count) VALUES " . join (', ', ("(?,?)") x scalar(keys(%$data)));
    query($dbh, $sql, %$data);
}



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

#Getting daily mails from the $emails_table table 
$sql = "SELECT addr FROM $emails_table";
my @data = query($dbh, $sql);

#Getting the domains counted
my %domains_count = dailyCount(\@data);

#Updating $results_table with daily emails
updateDomainCount($dbh, \%domains_count);

$dbh->disconnect;

#Sorting the domains by it count
# my @domains = sort {$domains_count{$b} <=> $domains_count{$a}} (keys(%domains_count));
# foreach my $domain (@domains)
# {
#    print "[$domain]:\t\t$domains_count{$domain}\n";
# }

# while (my ($domain, $ocur) = each(%domains_count))
# {
#    print "[$domain]: $ocur\n";
# }

__END__