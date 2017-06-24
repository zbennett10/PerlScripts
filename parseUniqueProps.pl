use strict;
use warnings;

#This is a script that parses json for unique property names
#This script will search through every level of object nesting

print 'Enter output filename';
my $fileName = <STDIN>;
chomp $fileName;

print 'Enter path to file';
my $readPath = <STDIN>;
chomp $readPath;

open(my $fh, '<'.$readPath)
    or die "Couldn't open file '$readPath'";

my @jsonLines;
my @jsonProps;
my $jsonString;
my %csvMap;
my @uniqueProps;


#read lines in file - rmeove all whitespace
while(my $line = <$fh>) {
    $line =~ s/\s+//g;

    if ($line =~ /^\S*$/) { #if lines are empty, don't push
        push @jsonLines, $line
    }
}
close $fh;

$jsonString = join('', @jsonLines);

#get property names from json string
(@jsonProps) = $jsonString =~ /(\,"\S.+?|\{"\S.+?)"/g;

#remove brackets and quotations from props
foreach(@jsonProps) {
    s/\{/,/g;
    s/\"//g;
}
#remove first comma
#$jsonProps[0] =~ s/^,//;

#remove any commas from props
foreach(@jsonProps) {
    s/\,//g;
}

#initialize hash to store unique properties
my %hash;
@hash{@jsonProps}=(); #fill hash with properties from json

foreach(keys %hash) {
    push @uniqueProps, $_;
}

open($fh, '>'.$fileName) or die "Couldn't  open new file: $fileName";

print $fh join(',', @uniqueProps);

close $fh;
