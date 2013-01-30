#!/usr/bin/perl

use strict;
use warnings;

use GUI::DB qw(dbConnect query);


#Check a table's existence
#Parameters: Database handler, table name
#Returns: true if it exists, false otherwise
sub tableExists
{
    my $dbh = shift;
    my $table = shift;
    my @tables = $dbh->tables('','','','TABLE');
    if (@tables)
    {
        for (@tables)
        {
            next unless $_;
            return 1 if $_ eq $table
        }
    }
    else
    {
        eval
        {
            local $dbh->{PrintError} = 0;
            local $dbh->{RaiseError} = 1;
            $dbh->do(qq{SELECT * FROM $table WHERE 1 = 0 });
        };
        return 1 unless $@;
    }
    return 0;
}


my results_table = "emails_top";

my $dbh = dbConnect();
my $sql;

#creating the results database
if (!tableExists($dbh, $results_table))
{
    $sql = "CREATE TABLE $results_table (
                id INT NOT NULL AUTO_INCREMENT PRIMARY KEY, 
                domain VARCHAR(255) NOT NULL,
                daily_count INT,
                cur_timestamp TIMESTAMP(8))";
    print "creando tabla\n";
}
else
{
    print "que cojones paso\n";
}


#making a query
# $sql = 'SELECT addr FROM mailing WHERE addr = \'s2mh@schone.biz\'';
# my @data = &query($dbh, $sql);
# print $data[0]->{addr};

__END__