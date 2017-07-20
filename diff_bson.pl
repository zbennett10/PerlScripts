#!/bin/perl
use strict;
use List::Util qw[min max];

#take in a path to two bson files or one bson file and one json file or 2 json files
my ($diffeePath, $differPath) = @ARGV;
my @diffeeLines;
my @differLines;

#bsondump the bson file to a json file
&readFile($diffeePath, "diffee");
&readFile($differPath, "differ");

unlink "tmp_differ.json";
unlink "tmp_diffee.json";

my $diffeeLineCount = scalar @diffeeLines;
my $differLineCount = scalar @differLines;
my $checkLength = max($diffeeLineCount, $differLineCount);
my $differenceCount = 0;

if($diffeePath =~ /.*\/(.*)/g) {
    $diffeePath =~ /.*\/(.*)/g;
    print "\n", $1, " compared to $differPath\n";
} else {
    print "\n", $diffeePath, " compared to $differPath\n";
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

#subroutines
sub readFile {
    my ($filePath, $diffType) = @_;
    if(&checkFileType($filePath) eq "bson") { 
        system("bsondump --quiet $filePath > tmp_".$diffType.".json");
        open my $file , '<', "tmp_".$diffType."json" or die "Couldn't open file $filePath";
        while(<$file>) {
            if($diffType eq "diffee") {
                push(@diffeeLines, $_);
            } else {
                push(@differLines, $_);
            }
        }
        close $file;
    }

    if(&checkFileType($filePath) eq "json") {
        open my $file, '<', $filePath or die "Couldn't open file at $filePath";
        while(<$file>) {
            if($diffType eq "diffee") {
                push(@diffeeLines, $_);
            } else {
                push(@differLines, $_);
            }
        }
        close $file;
    }
}

sub checkFileType {
    my ($path) = @_;
    return "bson" if $path =~ /.bson/g;
    return "json" if $path =~ /.json/g;
}