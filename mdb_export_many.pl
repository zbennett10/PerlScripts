#!/usr/bin/perl
use strict;
use warnings;

#this is a script getting every collection name in a database and exporting it as json

my ($database, $directoryPath) = @ARGV;


if(! $database) { #check for required database argument
    die "A database argument must be provided to the script. Ex: perl mongorestore.pl wasp";
}

#if a directory path is not given in arguments, operate in the current directory.
if(!$directoryPath) {
    $directoryPath = '.';
}

my $collectionString = `mongo wasp --quiet --eval db.getCollectionNames()`;
my @collectionNames;

while($collectionString =~ /(\w+)/g) {
    push(@collectionNames, $1);
}

exportMongoCollections(@collectionNames);
#subroutine that takes an array of json files and imports them to the given mongodb database
sub exportMongoCollections {
    foreach my $collection (@_) {
        system("mongoexport -d $database -c $collection --jsonArray --pretty --out $directoryPath/$collection.json");
        }
}