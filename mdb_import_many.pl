#!/usr/bin/perl
use strict;
use warnings;

#this is a script for enumerating over every json file in a folder and importing it into mongodb

my ($database, $directoryPath) = @ARGV;

if(! $database) { #check for required database argument
    die "A database argument must be provided to the script. Ex: perl mongorestore.pl wasp";
}

#if a directory path is not given in arguments, operate in the current directory.
if(!$directoryPath) {
    $directoryPath = '.';
}

#open directory and import json files to mongo
opendir my $dir, $directoryPath or die "Cannot open directory at path $directoryPath.";
my @files = readdir $dir;
importJSONToMongo(@files);
closedir $dir;

#subroutine that takes an array of json files and imports them to the given mongodb database
sub importJSONToMongo {
    foreach my $file (@_) {
        if($file =~ /.json/) { #only import json files - need to make this regex better (it would match *.metadata.json and other extraneous files)

        $file =~ /(^.+?)(?=\.)/; #capture the filename before the '.json' extension
        system("mongoimport -d $database -c $1 --jsonArray --file $directoryPath/$1.json");
        }
    }
}
