#!/usr/bin/perl
use strict;
use warnings;

my $htmlFile = "index.html";

unless(open FILE, '>'.$htmlFile) {
    die "\nUnable to create html index file\n";
}

print FILE "<!doctype html>\n<html>\n\t<head>\n\t\t<meta charset='utf-8'>\n\t<head>\n\t<body>\n\t\t<div>Hello World</div>\n\t</body>\n</html>";

close FILE;
