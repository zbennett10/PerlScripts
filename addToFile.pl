#!/usr/bin/perl
use strict;
use warnings;

print "\nEnter path to text file.\n";
my $editPath = <STDIN>;
chomp $editPath;

print "\nEnter value to add to each line.\n";
my $textAddition = <STDIN>;
chomp $textAddition;

print "\nEnter output path.\n";
my $outputPath = <STDIN>;
chomp $outputPath;

open(my $fh, "<", $editPath)
    or die "Could not open file '$editPath'";

my @lines = ();
while (my $line = <$fh>) {
    chomp $line;
    $line = $line.$textAddition;
    push @lines, $line;
}
close $fh;

#output altered text;
unless(open FILE, ">".$outputPath) {
    die "Could not open file '$outputPath'";
}

foreach(@lines) {
    print FILE;
}
    close FILE;