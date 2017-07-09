#!/bin/perl
use strict;
use List::Util qw[min max];


#take in a path to two bson files or one bson file and one json file or 2 json files
my ($diffeePath, $differPath) = @ARGV;
my @diffeeLines;
my @differLines;

#bsondump the bson file to a json file
if(&checkFileType($diffeePath) eq "bson") { 
    system("bsondump --quiet $diffeePath > tmp_diffee.json");
    open my $diffeeJSON , '<', 'tmp_diffee.json' or die "Couldn't open file $diffeePath";
    while(<$diffeeJSON>) {
        push(@diffeeLines, $_);
    }
    close $diffeeJSON;
}

if(&checkFileType($diffeePath) eq "json") {
    open my $diffeeJSON, '<', $diffeePath or die "Couldn't open file at $diffeePath";
    while(<$diffeeJSON>) {
        push(@diffeeLines, $_);
    }
    close $diffeeJSON;
}

if(&checkFileType($differPath) eq "bson") {
    system("bsondump --quiet $differPath > tmp_differ.json");
    open my $differJSON , '<', 'tmp_differ.json' or die "Couldn't open file $differPath";
    while(<$differJSON>) {
        push(@differLines, $_);
    }
    close $differPath;
}

if(&checkFileType($differPath) eq "json") {
    open my $differJSON , '<', $differPath or die "Couldn't open file $differPath";
    while(<$differJSON>) {
        push(@differLines, $_);
    }
    close $differPath;
}

unlink "tmp_differ.json";
unlink "tmp_diffee.json";

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
    my ($path) = @_;
    if($path =~ /.bson/g) {return "bson";}
    if($path =~ /.json/g) {return "json";}
}

#TODO - 
#make the arguments interchangeable -- allow for diffing files in any order
#allow diffing of two bson files - not just one bson/one json