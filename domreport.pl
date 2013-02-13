#!/usr/bin/perl

############
#        $Id$
#Description: Given a emails table, this script creates and updates another table which holds a daily count of email 
#             addresses by their domain name. The new table is used to report the top 50 domains by count sorted by
#             percentage growth of the last 30 days.
#    $Author$ Lionel Aster Mena Garcia
#      $Date$
#  $Revision$
############

use strict;
use warnings;

use GUI::DB qw(dbConnect query);
use POSIX;

# DB TABLES
our $emails_table = "mailing";
our $results_table = "domains_count";


#tableExists($dbh, 'table_name')
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

#dailyCount(\@data)
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
        my ($username, $domain) = split(/@/, $row->{addr});
        if (exists($elements{$domain}))
        {
            $elements{$domain}++;
        }
        else
        {
            $elements{$domain} = 1;
        }
        
    }
    return %elements;  
}

#top50($dbh)
#Calculates the top 50 domains by count
#Parameters: Database handler,
#Returns: Array of the query (array of hashe's references) with the top 50 domains
#
sub top50
{
    my $dbh = shift;
    my %tmp = ();

    # my $sql = "SELECT  domain, max(daily_count) from $results_table GROUP BY domain";
    my $sql = "SELECT  domain, daily_count
               FROM $results_table
               ORDER BY daily_count DESC LIMIT 500";
    my @data = query($dbh, $sql);

    # I had to use a for loop because of the index modification inside the loop
    for (my $i = 0; $i <= $#data; $i++)
    {
        if (!exists($tmp{$data[$i]->{domain}}))
        {
            $tmp{$data[$i]->{domain}} = undef;
            if (scalar(keys(%tmp)) == 50)
            {
                last;
            }
            
        }
        else
        {
            splice(@data, $i, 1);
            $i--;
            
        }
    }

    return @data[0..49];
}

#
#Calculates the domain's growth percentge of the last 30 days compared to the total
#Parameters: Database handler, DBI query array with the top 50 domains
#Returns: DBI query array modified to include the growth percentage of each doamin
#
sub growthEvolution
{
    my $dbh = shift;
    my @dtop = @_;

    foreach my $row (@dtop)
    {
        my $sql = "SELECT domain, daily_count FROM $results_table 
                   WHERE domain = ? AND  (CURDATE() - INTERVAL 30 DAY) <= cur_timestamp
                   ORDER BY cur_timestamp ASC LIMIT 1";
        my @data = query($dbh, $sql, $row->{domain});

        #calculating the growth percentage of the last 30 days
        #growth = [(Vpresent - Vpast) / Vpast] * 100
        my $v_past = $data[0]->{daily_count};
        my $v_present = $row->{daily_count};
        $row->{growth_last} = floor((($v_present - $v_past) / $v_past) * 100);
    }

    return @dtop;
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
# $sql = "SELECT addr FROM $emails_table";
# my @data = query($dbh, $sql);

# #Getting the domains counted
# my %domains_count = dailyCount(\@data);

# #Updating $results_table with daily emails
# $sql = "INSERT INTO $results_table (domain, daily_count) VALUES " . join (', ', ("(?,?)") x scalar(keys(%domains_count)));
# query($dbh, $sql, %domains_count);

#Getting the top 50 domain
my @dtop = top50($dbh);

@dtop = growthEvolution($dbh, @dtop);

#Sorting the domains by its growth percentages
my @dtop_sorted = sort {$b->{growth_last} <=> $a->{growth_last}} @dtop;

my $index = 1;
printf "%-2s %-20s %-8s  %-8s\n","#", "Domain", "Total Count", "30-days Growth (%)";
foreach my $row (@dtop_sorted)
{
    print "----------------------------------------------------\n";
    printf "%-2u %-23s %-11u %-4u%%\n", $index, $row->{domain}, $row->{daily_count}, $row->{growth_last};
    $index++;
}

$dbh->disconnect();

__END__