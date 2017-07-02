#!/bin/perl
use strict;
use warnings;

#take in a path to a bson file and a path to a json file
my ($bsonPath, $jsonPath) = @ARGV;


#bsondump the bson file to a json file
#create an empty hash table
#find the differences between the files by line
#for each difference, add a new hash to the hash table where the key is the difference number (0,1,2) and the value is an array of hash tables [firstLine#: firstlineText, secondLine#: secondLineText]
