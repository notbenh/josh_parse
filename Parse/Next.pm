package Parse::Next;
use strict;
use warnings;
use base qw{Parse};

sub why_choose_unilodge { shift->{why_choose_unilodge} || 5 }
sub female_attendance   { shift->{female_attendance}   || 13 }
sub female_percentage   { my $s = shift; ($s->female_attendance / $s->total_attendance)*100}
sub male_attendance     { shift->{male_attendance}     || 29 }
sub male_percentage     { my $s = shift; ($s->male_attendance / $s->total_attendance)*100}
sub total_attendance    { my $s = shift; $s->female_attendance + $s->male_attendance}
# NOTE: Quoting matters
sub website             { shift->{website}             || q{'google.com'} }

1;
