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

__END__
( ( male_attendance / ( female_attendance + male_attendance ) ) > 90 )
( female_attendance + male_attendance ) > 90
(male_attendance  > 90)
(male_attendance  >= 90)
(male_attendance  >= 90)
website = 'strategicdata.com.au'
default
