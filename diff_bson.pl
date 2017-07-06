#!/bin/perl
use strict;
use warnings;
use List::Util qw[min max];

#take in a path to a bson file and a path to a json file
my ($bsonPath, $jsonPath) = @ARGV;

#bsondump the bson file to a json file
system("bsondump $bsonPath > output.json");
open my $outputJSON , '<', 'output.json';
my @bsonLines;
while(my $line = <$outputJSON>) {
    chomp($line);
    $line =~ s/\s//g;
    push(@bsonLines, $line);
}

open my $jsonFile , '<', $jsonPath or die "Couldn't open";
my @jsonLines;
while(my $line = <$jsonFile>) {
    chomp($line);
    $line =~ s/\s//g;
    push(@jsonLines, $line);
}

close $outputJSON;
close $jsonFile;

my $bsonLineLength = scalar @bsonLines;
my $jsonLineLength = scalar @jsonLines;
my $checkLength = max($bsonLineLength, $jsonLineLength);
my $differenceCount = 0;

#compare bson file line by line with json file

MAIN: for(my $i = 0; $i < $checkLength; $i++) {
    my $bsonLine = $bsonLines[$i];
    my $jsonLine = $jsonLines[$i];

    if($bsonLine ne $jsonLine) {

        #check if line is in json file but has moved
        for(my $j = $i + 1; $j < length(@jsonLines); $j++) {
            if($bsonLine eq $jsonLines[$j]) {
                print 'Line moved -- '.$bsonLine." from line ", $i + 1, " to ", $j + 1.;
                $differenceCount++;
                next MAIN;
            }
        }

        #the line isn't found - if json file is longer
        if(scalar @jsonLines > scalar @bsonLines) {
            print $i + 1, ' -----'.$jsonLine."\n";
            $differenceCount++;
        }

        if(scalar @bsonLines > scalar @jsonLines) {
            print $i + 1, ' +++++'.$bsonLine."\n";
            $differenceCount++;
        }

    } 
}

if($differenceCount > 0) {
    print "\nFound ".$differenceCount." line differences.\n";
} else {
    print "\nNo differences found.\n";
}

#fix the above to determine if records were removed and display the removed records
#determine which records were changed and display the changed records


#bsondump the bson file to a json file
#create an empty hash table
#find the differences between the files by line
#for each difference, add a new hash to the hash table where the key is the difference number (0,1,2) and the value is an array of hash tables [firstLine#: firstlineText, secondLine#: secondLineText]
