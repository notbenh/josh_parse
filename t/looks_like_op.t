#!/usr/bin/env perl
use strict;
use warnings;
use v5.10;
 
use Test::More qw{no_plan};

use lib '..';
use_ok 'Parse';
ok my $p = Parse->new, q{can build an obj};

can_ok( $p, 'looks_like_op' );

for (qw/
  (
  ((
  (((
  )))
  ))
  )
/) {
  my ( $op ) = $_;

  ok( Parse::looks_like_op( $op ), $op );
}
