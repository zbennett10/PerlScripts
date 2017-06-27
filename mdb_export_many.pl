#!/usr/bin/perl
use strict;
use warnings;

#this is a script for enumerating over every json file in a folder and importing it into mongodb

my ($database, $collectionNames, $directoryPath) = @ARGV;
my @collections = split(',', $collectionNames);



if(! $database) { #check for required database argument
    die "A database argument must be provided to the script. Ex: perl mongorestore.pl wasp";
}

if(scalar @collections < 1) {
    die "Must provide a comma seperated list of collections to export.";
}


#if a directory path is not given in arguments, operate in the current directory.
if(!$directoryPath) {
    $directoryPath = '.';
}

exportMongoCollections(@collections);
#subroutine that takes an array of json files and imports them to the given mongodb database
sub exportMongoCollections {
    foreach my $collection (@_) {
        system("mongoexport -d $database -c $collection --jsonArray --pretty --out $directoryPath/$collection.json");
        }
}