#!/usr/bin/perl

use strict;
use warnings;

use feature ':5.10';
use Data::Dumper;

my $string = "(foo > 9) or website = 'strategicdata.com.au'";

print Dumper [ map { $_ eq '=' ? '==' : $_ } grep{ length and $_ ne ' ' } split ( /(\b|\s|'.+')/, $string ) ];
