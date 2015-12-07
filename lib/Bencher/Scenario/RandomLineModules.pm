package Bencher::Scenario::RandomLineModules;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

our $scenario = {
    participants => [
        {
            fcall_template => "File::Random::Pick::random_line(<file>)",
        },
    ],
};

1;
# ABSTRACT: Benchmark modules which pick random line(s) from a file

=head1 SYNOPSIS

 % bencher -m RandomLineModules [other options]...
