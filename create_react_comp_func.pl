#!/usr/bin/perl
use strict;
use warnings;

print "\nEnter functional component name...\n";

my $componentName = <STDIN>;
chomp $componentName;
my $reactFile = $componentName . ".js";


unless(open FILE, '>'.$reactFile) {
    die "Unable to scaffold functional component..";
}

print FILE "import React from 'react';\n\nexport default (props) => {\n\treturn(\n\t\t<div>Hello World</div>\n\t)\n}";
print "\nCreated functional component - $componentName - in current directory.\n";

close FILE;