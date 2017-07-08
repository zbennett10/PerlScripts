#!/usr/bin/perl
use strict;
use warnings;

my $maximum = &max(3,5,6,4,10);
print $maximum;

sub max {
    my ($max) = shift @_;
    foreach (@_) {
        if($_ > $max) {
            $max = $_;
        }
    }
    $max;
}

