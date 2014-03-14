#!/usr/bin/env perl
use strict;
use warnings;
use v5.10;
 
use Test::More qw{no_plan};

require_ok q{Parse};
ok my $p = Parse->new, q{can build an obj};
ok  Parse::looks_like_op('eq'), qq{eq op check};
ok !Parse::looks_like_op('!!'), qq{!! op check};
ok  Parse::is_quoted(q{'123'}), qq{123 quote check};
ok !Parse::is_quoted('eq')    , qq{eq quote check};
is $p->parse([{false => 0}, {true => 1}]),'true', q{bool};
is $p->parse([{false => 0}, {true => default =>}]),'true',q{bool by default};
is $p->parse([{10 => '1 + 1 == 2'}]), 10, qq{1+1==2};

__END__
require_ok q{Parse::Next};
$p = Parse::Next->new;

# first call to parse_* loads up data for you so you can just call
# parse() directly later with no input
is $p->parse_yaml_file('./t/test_data.yaml'), 'PAGE_002', q{PAGE_002};
$p->{website} = 'yahoo.com';
is $p->parse, 'PAGE_003', q{PAGE_003};
$p->{why_choose_unilodge} = 6;
is $p->parse, 'PAGE_004', q{PAGE_004};
$p->{why_choose_unilodge} = 'not looking here any more';

is $p->parse, 'PAGE_007', q{PAGE_007};
$p->{female_attendance} = 80;
is $p->parse, 'PAGE_008', q{PAGE_008};
$p->{male_attendance} = 13;
$p->{female_attendance} = 180;
is $p->parse, 'PAGE_009', q{PAGE_009};
$p->{female_attendance} = 90;
is $p->parse, 'PAGE_010', q{PAGE_010};


__END__
