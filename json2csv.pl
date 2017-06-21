use strict;
use warnings;
#use Class::CSV;

print 'Enter output filename';
my $fileName = <STDIN>;
chomp $fileName;

print 'Enter path to file';
my $readPath = <STDIN>;
chomp $readPath;

open(my $fh, '<'.$readPath)
    or die "Couldn't open file '$readPath'";

my @jsonLines;
my %csvMap;

while(my $line = <$fh>) {
    push @jsonLines, $line;
}

my $lineCount = scalar @jsonLines - 1;

close $fh;

my $index = 1;
for my $line (@jsonLines) {
    print 'line '.$index, "\n";
    print $line, "\n";
    $index++;
}

# my $csv = Class::CSV->parse(
#     filename => $fileName,
#     fields => qw()
# )

#close $fh;