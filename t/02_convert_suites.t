use Test::Base;
use FindBin;
use WWW::Selenium::Selenese::TestSuite qw/bulk_convert_suite/;

plan tests => 2;

my $suites_dir = "$FindBin::Bin/convert_suites";
opendir(DIR, $suites_dir) or die $!;
my @dirs = grep { /^[^.]/ && -d "$suites_dir/$_" } readdir(DIR);
closedir(DIR);

foreach my $dir (@dirs) {
    bulk_convert_suite("$suites_dir/$dir/suite.html");
    opendir(DIR, "$suites_dir/$dir") or die $!;
    my @plfiles = grep { /\.pl$/ } readdir(DIR);
    closedir(DIR);
    foreach my $plfile (@plfiles) {
        open my $io, '<', "$suites_dir/$dir/$plfile" or die $!;
        my $got = join '', <$io>;
        close $io;
        open $io, '<', "$suites_dir/$dir/expected/$plfile" or die $!;
        my $expected = join '', <$io>;
        close $io;
        is( $got, $expected, "$plfile - output precisely" );
        unlink "$suites_dir/$dir/$plfile";
    }
}
