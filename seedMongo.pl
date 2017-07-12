#!usr/bin/perl
use strict;
use warnings;

#this script takes optional file path parameters to json or bson but is meant to be applied to all files of the same type within a directory
# EX:  perl seedMongo.pl *.json

my $database = shift @ARGV;

