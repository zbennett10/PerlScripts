use 'strict';
use 'warnings';
use Class::CSV;

print 'Enter output filename';
my $fileName = <STDIN>;
$fileName.chomp();

my $csv = Class::CSV->parse(
    filename => $fileName,
    fields => qw()
)