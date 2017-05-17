#!/usr/bin/perl
use strict;
use warnings;

print "Enter component name:\n";

my $componentName = <STDIN>;
chomp $componentName;
my $reactFile = $componentName . ".js";

unless(open FILE, '>'.$reactFile) {
    die "\nUnable to create javascript file.\n";
}

print FILE "import React, {Component} from 'react';\n\nexport default class $componentName extends Component {\n\tconstructor(props) {\n\t\tsuper();\n\t}\n\n\trender() {\n\t\treturn <div>Hello World</div>\n\t}\n}";

close FILE;