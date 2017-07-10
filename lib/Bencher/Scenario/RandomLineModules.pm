package Bencher::Scenario::RandomLineModules;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;
use Log::ger;

sub _create_file {
    my ($num_lines) = @_;

    require File::Temp;
    my ($fh, $filename) = File::Temp::tempfile();
    for (1..$num_lines) {
        print $fh sprintf("%049d\n", $_);
    }
    $filename;
}

our $scenario = {
    summary => 'Benchmark modules which pick random line(s) from a file',
    participants => [
        {
            fcall_template => 'File::Random::Pick::random_line(<filename>)',
        },
        {
            module => 'File::RandomLine',
            code_template => 'my $rl = File::RandomLine->new(<filename>); $rl->next',
        },
    ],

    datasets => [
        {name=>'1k_line'  , _lines=>1_000     , args=>{filename=>undef}},
        {name=>'10k_line' , _lines=>10_000    , args=>{filename=>undef}},
        {name=>'100k_line', _lines=>100_000   , args=>{filename=>undef}, include_by_default=>0},
        {name=>'1M_line'  , _lines=>1_000_000 , args=>{filename=>undef}, include_by_default=>0},
        {name=>'10M_line' , _lines=>10_000_000, args=>{filename=>undef}, include_by_default=>0},
    ],

    before_gen_items => sub {
        my %args = @_;
        my $sc    = $args{scenario};

        my $dss = $sc->{datasets};
        for my $ds (@$dss) {
            log_info("Creating temporary file with %d lines ...", $ds->{_lines});
            my $filename = _create_file($ds->{_lines});
            log_info("Created file %s", $filename);
            $ds->{args}{filename} = $filename;
        }
    },

    before_return => sub {
        my %args = @_;
        my $sc    = $args{scenario};

        my $dss = $sc->{datasets};
        for my $ds (@$dss) {
            my $filename = $ds->{args}{filename};
            next unless $filename;
            log_info("Unlinking %s", $filename);
            unlink $filename;
        }
    },
};

1;
# ABSTRACT:
