#!/usr/bin/perl

use strict;
use warnings;

use feature ':5.10';
use Data::Dumper;

use lib '..';
use Parse;

my $p = Parse->new;

print Dumper $p->parse_yaml_file( 'parse_me.yaml' );
