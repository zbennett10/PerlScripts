#!/bin/perl
use strict;
use List::Util qw[min max];


#take in a path to a bson file and a path to a json file
my ($diffeePath, $differPath) = @ARGV;
my @diffeeLines;
my @differLines;

#bsondump the bson file to a json file
system("bsondump --quiet $diffeePath > output.json");
open my $outputJSON , '<', 'output.json' or die "Couldn't open file $diffeePath";
while(<$outputJSON>) {
    push(@diffeeLines, $_);
}

open my $differFile , '<', $differPath or die "Couldn't open file $differPath";
while(<$differFile>) {
    push(@differLines, $_);
}


close $outputJSON;
unlink "";
close $differFile;

my $diffeeLineCount = scalar @diffeeLines;
my $differLineCount = scalar @differLines;
my $checkLength = max($diffeeLineCount, $differLineCount);
my $differenceCount = 0;

if($diffeePath =~ /.*\/(.*)/g) {
    $diffeePath =~ /.*\/(.*)/g;
    print "\n", $1, "\n";
} else {
    print "\n", $diffeePath, "\n";
}

#compare bson file line by line with json file
MAIN: for(my $i = 0; $i < $checkLength; $i++) {
    my $diffeeLine = $diffeeLines[$i];
    my $differLine = $differLines[$i];
    if($diffeeLine ne $differLine) {
        for(my $j =  0; $j < @differLines; $j++) { #check if line is in json file but has moved - if it has ignore it
            if($diffeeLine eq $differLines[$j]) {
                next MAIN;
            }
        }

        if(@differLines > @diffeeLines) { #the line isn't found - if json file is longer
            print "\n", $i + 1, ' -----'.$differLine."\n";
            $differenceCount++;
        }

        if(@diffeeLines > @differLines) {
            print "\n", $i + 1, ' +++++'.$diffeeLine."\n";
            $differenceCount++;
        }
    } 
}

if($differenceCount > 0) {
    print "\nFound ".$differenceCount." line".($differenceCount > 1 ? " differences" : " difference")."\n";
} else {
    print "\nNo differences found.\n";
}


sub checkFileType {
    if($_ =~ /.bson/g) {"bson";}
    if($_ =~ /.json/g) {"json";}
}

#TODO - 
#make the arguments interchangeable -- allow for diffing files in any order
#allow diffing of two bson files - not just one bson/one json