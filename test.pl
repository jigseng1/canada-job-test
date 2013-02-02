#!/usr/bin/perl

use strict;
use warnings;

use GUI::DB qw(dbConnect query);

# DB TABLES
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
#Updates the table $results_table with the daily domain's counting
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


#
#Calculates the top 50s domains by count
#Parameters: Database handler,
#Returns: Array with the top 50 domains
#
sub top50
{
    my $dbh = shift;
    my %dtop = ();

    # my $sql = "SELECT  domain, max(daily_count) from $results_table GROUP BY domain";
    my $sql = "SELECT  domain, daily_count
               FROM $results_table 
               ORDER BY daily_count DESC";
    my @data = query($dbh, $sql);

    foreach my $row (@data)
    {
        if (!exists($dtop{$row->{domain}}))
        {
            if (scalar(keys(%dtop)) != 50)
            {
                $dtop{$row->{domain}} = $row->{daily_count};
            }
            else
            {
                last;
            }
        }
    }

    return %dtop;
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
# my @data = query($dbh, $sql);

#Getting the domains counted
# my %domains_count = dailyCount(\@data);

#Updating $results_table with daily emails
# updateDomainCount($dbh, \%domains_count);

#Getting the top 50 domain
my %dtop = top50($dbh);
my @domains = sort {$dtop{$b} <=> $dtop{$a}} (keys(%dtop));
foreach my $domain (@domains)
{
    print "[$domain]: \t $dtop{$domain}\n";
}

$dbh->disconnect();

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