project SVN repository: http://code.google.com/p/canada-job-test/

System's development specifications: perl v5.14.2
                                     mysql v5.5.29

# Input: 
    
    I wrote a small script to generates emails randomly, the script use a set of domains contained in the file domains_list.txt.

            Usage: mailgen.pl output_file emails_number

    It needs two extra CPAN modules dependencies:

        - File::RandomLine   http://search.cpan.org/~dagolden/File-RandomLine-0.19/lib/File/RandomLine.pm
        - String::Random    http://search.cpan.org/~steve/String-Random-0.22/lib/String/Random.pm

    I used "mailgen.pl" to generate 44 days of random emails simulation (300,000 emails/day), due to its size it wasn't included (6 MB per file). Additionally, I uploaded a snapshot of the "test" database containing the 44 days simulated. It can be downloaded from: 

            http://canada-job-test.googlecode.com/files/dbdump2.db.bz2

            Usage: mysql test < dbdump.db

    I wrote another script to insert the generated emails into the "mailing" table. The script optionally truncate the table.

            Usage: tableUpdate.pl emails_file [-t]

# Script domreport.pl:              

    The script count the domain's ocurrences, updates the table print the report to the standar output (it's better use Linux IO redirections).

    I tried to stick as much as possible to the limitations indicated in the test. However, I have made some SQL queries with the WHERE clause in favor of efficiency. 

    Because the meaning of "total" was not specified on the test, the script calculates the growth percentage of the last 30 days without compare to the "total". I guessed the total could be the growth percentage of the last year, but it always going to be higher than the monthly growth so it doesn't make sense.

    Quoting: "Use this table to report the top 50 domains by count sorted by percentage growth of the last 30 days compared to the TOTAL."

    It is suggested to comment lines 140 from 148 if only the daily report is desired.

# Output: It comes with the last 12 days reports (2013-02-02 ~ 2013-02-13)
