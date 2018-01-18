#!/usr/bin/perl
use strict;
use warnings;
use XML::LibXML;
use Data::Dumper;

#get input/output filenames from stdin
my ($kmlFileName, $csvFileName) = @ARGV;

#get parsed, traversable KML
my $kmlFile = XML::LibXML->new->parse_file($kmlFileName);

#set lines
my @x_y_alt_lines;
my @name_lines;
my @data_lines;

for my $coordinate_node ($kmlFile->findnodes('//*[local-name()="coordinates"]')) {
    my $text = $coordinate_node->textContent;
    chomp $text;
    push @x_y_alt_lines, $text;
}

for my $name_node ($kmlFile->findnodes('//*[local-name()="name"]')) {
    unless($name_node->textContent eq "WAYPOINTS") {
        my $text = $name_node->textContent;
        chomp $text;
        push @name_lines, $text;
    }
}

my @data_keys = qw(dtdid fix_rrr_ddd remarks latitude longitude exp_alt time_from_to time_to_td c1 c2 c3 c4);
my @ext_data_nodes = $kmlFile->findnodes('//*[local-name()="ExtendedData"]');
my @all_node_key_values = ();

my $node_index = 0;
foreach my $ext_data_node (@ext_data_nodes) {
    my @data_nodes = $ext_data_node->nonBlankChildNodes();

    push @all_node_key_values, [];
    my $data_node_key_values = "";
    foreach my $data_node (@data_nodes) {
        my @attributes = $data_node->attributes;
        my $attribute = $attributes[0];
        $attribute =~ s/name\=\"//;
        $attribute =~ s/\"//;
        $attribute =~ s/\s|\//_/g;
        $attribute =~ s/_//;
        $attribute = lc $attribute;

        my @value_nodes = $data_node->nonBlankChildNodes();
        my $value_node = $value_nodes[0];

        my $text_value = $value_node->textContent;
        $data_node_key_values = $data_node_key_values.$attribute.",".$text_value.",";
    }

    chop $data_node_key_values;
    my %node_hash = split(",", $data_node_key_values);

    unless($node_hash{'remarks'}) {
        $node_hash{'remarks'} = "N/A";
    }

    $all_node_key_values[$node_index] = \%node_hash;
    
    $node_index++;
}

foreach (@all_node_key_values) {
    my $node_line = "";
    foreach my $key (@data_keys) {
        my $value = $_->{$key} || 'N/A';
        $node_line = $node_line.",".$value;
    }
    $node_line = $node_line."\n";
    if(substr($node_line, 0, 1) eq ',') {
        $node_line =~ s/^.//s;
    }
    push @data_lines, $node_line;
}

my $index = 0;
my $csvString = "x,y,altitude,name,dtdid,fix_rrr_ddd,remarks,latitude,longitude,exp_alt,time_from_to,time_to_td,c1,c2,c3,c4\n";

for (@name_lines) {
    $csvString = $csvString.$x_y_alt_lines[$index].",".$_.",";
    $csvString = $csvString.$data_lines[$index];
    $index++;
}

open my $csvFile, '>', $csvFileName or die "\nCouldn't open file at ./$csvFileName\n";
print $csvFile $csvString;
close $csvFile;
