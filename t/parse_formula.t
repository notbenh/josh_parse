#!/usr/bin/env perl
use strict;
use warnings;
use v5.10;
 
use Test::More qw{no_plan};
use Test::LongString;

use lib '..';
use_ok 'Parse';
ok my $p = Parse->new, q{can build an obj};

can_ok( $p, 'parse_formula' );

for (
  # in    out
  [ 'why_choose_unilodge=5',                    q{$session->get('why_choose_unilodge') == 5} ],
  [ 'why_choose_unilodge = 6',                  q{$session->get('why_choose_unilodge') == 6} ],
  [ 'female_attendance + male_attendance > 50', q{$session->get('female_attendance') + $session->get('male_attendance') > 50} ],
  [ 'male_attendance != 13',                    q{$session->get('male_attendance') != 13} ],
  [ 'female_attendance < 1',                    q{$session->get('female_attendance') < 1} ],
  [ '(( (female_attendance / ( female_attendance + male_attendance ) ) > 90 ) or ( ( male_attendance / ( female_attendance + male_attendance ) ) > 90 ) )', q{(( ( $session->get('female_attendance') / ( $session->get('female_attendance') + $session->get('male_attendance') ) ) > 90 ) or ( ( $session->get('male_attendance') / ( $session->get('female_attendance') + $session->get('male_attendance') ) ) > 90 ) )} ],
  [ '( ( male_attendance / ( female_attendance + male_attendance ) ) > 90 )', q{( ( $session->get('male_attendance') / ( $session->get('female_attendance') + $session->get('male_attendance') ) ) > 90 )} ],
  [ '( female_attendance + male_attendance ) > 90', q{( $session->get('female_attendance') + $session->get('male_attendance') ) > 90} ],
  [ '(male_attendance  > 90)', q{( $session->get('male_attendance') > 90 )} ],
  [ '(male_attendance  >= 90)', q{( $session->get('male_attendance') >= 90 )} ],
  [ "website = 'strategicdata.com.au'", q{$session->get('website') eq 'strategicdata.com.au'} ],
  [ 'default', 1 ],
  [ '5 == 5.00', q{5 == 5.00}],
  [ q{'five' = 'FIVE'}, q{'five' eq 'FIVE'} ],
  [ 'five = 5', q{$session->get('five') == 5} ],
  [ q{five = 'five'}, q{$session->get('five') eq 'five'} ],
) {
  my ( $formula, $expected ) = @$_;

  is_string(
    $p->parse_formula( $formula ),
    $expected,
    $formula,
  );
}

__END__
