use strict;
use warnings;

#this script is an implementation of the 'tac' command - the reverse of the 'cat' command
foreach(reverse @ARGV) {
    open FILE, '<'.$_;
    my @lines = reverse <FILE>;
    close FILE;

    foreach my $line (@lines) {
        print $line;
    }
}