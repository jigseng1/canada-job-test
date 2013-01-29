#!/usr/bin/perl

use strict;
use warnings;

use GUI::DB qw(dbConnect query);

#testing de DB module

my $dbh = &dbConnect();

#making a query

my $sql = 'SELECT addr FROM mailing WHERE addr = \'s2mh@schone.biz\'';
my @data = &query($dbh, $sql);
print $data[0]->{addr};

__END__