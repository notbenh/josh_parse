#!/usr/bin/env perl
use strict;
use warnings;
use v5.10;
 
use Test::More qw{no_plan};

require_ok q{Parse::SD};
ok my $p = Parse::SD->new, q{can build an obj};
is $p->parse_to_eval( '(( (female_attendance / ( female_attendance + male_attendance ) ) > 90 ) or ( ( male_attendance / ( female_attendance + male_attendance ) ) > 90 ) )' )
, q{(( ( $session->get('female_attendance') / ( $session->get('female_attendance') + $session->get('male_attendance') ) ) > 90 ) or ( ( $session->get('male_attendance') / ( $session->get('female_attendance') + $session->get('male_attendance') ) ) > 90 ) )} 
, q{matches};



