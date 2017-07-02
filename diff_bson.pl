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

for(my $i = 0; $i < $checkLength; $i++) {
    my $bsonLine = $bsonLines[$i];
    my $jsonLine = $jsonLines[$i];
    if($bsonLine ne $jsonLine && length($bsonLine) > length($jsonLine)) {
        print $i + 1, ' ++++'.$bsonLine."\n";
        print $i + 1, ' ----'.$jsonLine."\n";
    }

    if($bsonLine ne $jsonLine && length($jsonLine) > length($bsonLine)) {
        print $i + 1, ' ++++'.$jsonLine."\n";
        print $i + 1, ' ----'.$bsonLine."\n";
        print "\n";
    }
}

#fix the above to determine if records were removed and display the removed records
#determine which records were changed and display the changed records


#bsondump the bson file to a json file
#create an empty hash table
#find the differences between the files by line
#for each difference, add a new hash to the hash table where the key is the difference number (0,1,2) and the value is an array of hash tables [firstLine#: firstlineText, secondLine#: secondLineText]
