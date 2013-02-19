project SVN repository: http://code.google.com/p/canada-job-test/

System's development specifications: perl v5.14.2
                                     mysql v5.5.29

# Input: 
    
    I wrote a small script to generates emails randomly, the script use a set of domains contained in the file domains_list.txt.

            Usage: mailgen.pl output_file emails_number

    It needs two extra CPAN modules dependencies:

        - File::RandomLine   http://search.cpan.org/~dagolden/File-RandomLine-0.19/lib/File/RandomLine.pm
        - String::Random    http://search.cpan.org/~steve/String-Random-0.22/lib/String/Random.pm

    I used "mailgen.pl" to generate 44 days of random emails simulation (300,000 emails/day), due to its size it wasn't included (6 MB per file). Additionally, I uploaded a snapshot of the database "test" containing the 44 days simulated. It can be downloaded from: 

            http://canada-job-test.googlecode.com/files/dbdump2.db.bz2

            Usage: mysql test < dbdump2.db

    I wrote another script to insert the generated emails into the table "mailing". The script optionally truncate the table.

            Usage: tableUpdate.pl emails_file [-t]

    Take into consideration, that the table created/used to report the top 50 domains has a timestamp type column. This means that several days simulations should be done in real-time, otherwise this column must be modified manually to simulate and obtain reports properly. 

# Script domreport.pl:              

    I have assumed that the table "mailing" contains all mail addresses received up to date. In other words, each day the table is not emptied before adding new adresses. The script counts the domain's occurrences, updates the table "domains_count" and prints the report to the standar output (it's better use Linux IO redirections).

    I tried to stick as much as possible to the limitations indicated in the test. However, I have made some SQL queries with the WHERE clause in favor of efficiency. 

    Because the meaning of "total" was not specified on the test, the script calculates the growth percentage of the last 30 days without compare to the "total". I guessed the total could be the growth percentage of the last year, but it always going to be higher than the monthly growth so it doesn't make sense for me.

    Quoting: "Use this table to report the top 50 domains by count sorted by percentage growth of the last 30 days compared to the TOTAL."

    It is suggested to comment lines from 126 to 139 if only the daily report is desired.

# Output: 

    It comes with the last 12 days reports (2013-02-02 ~ 2013-02-13) when the table "mailing" had a total of 13,200,000 addresses (44 days were simulated).


