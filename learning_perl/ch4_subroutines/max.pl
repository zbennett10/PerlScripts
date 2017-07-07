#!/usr/bin/perl
use strict;
use warnings;

my $maximum = &max(3,5,10,4,6);
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

