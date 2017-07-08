#!/bin/perl
use strict;
use List::Util qw[min max];

#take in a path to a bson file and a path to a json file
my ($bsonPath, $jsonPath) = @ARGV;

#bsondump the bson file to a json file
system("bsondump --quiet $bsonPath > output.json");
open my $outputJSON , '<', 'output.json';
my @bsonLines;
while(my $line = <$outputJSON>) {
    # chomp($line);
    # $line =~ s/\s//g;
    push(@bsonLines, $line);
}

open my $jsonFile , '<', $jsonPath or die "Couldn't open";
my @jsonLines;
while(my $line = <$jsonFile>) {
    # chomp($line);
    # $line =~ s/\s//g;
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
        for(my $j =  0; $j < @jsonLines; $j++) { #check if line is in json file but has moved - if it has ignore it
            if($bsonLine eq $jsonLines[$j]) {
                next MAIN;
            }
        }

        if(@jsonLines > @bsonLines) { #the line isn't found - if json file is longer
            print "\n", $i + 1, ' -----'.$jsonLine."\n";
            $differenceCount++;
        }

        if(@bsonLines > @jsonLines) {
            print "\n", $i + 1, ' +++++'.$bsonLine."\n";
            $differenceCount++;
        }
    } 
}

if($differenceCount > 0) {
    print "\nFound ".$differenceCount." line".($differenceCount > 1 ? " differences" : " difference")."\n";
} else {
    print "\nNo differences found.\n";
}


#TODO - 
#make the arguments interchangeable -- allow for diffing files in any order
#allow diffing of two bson files - not just one bson/one json