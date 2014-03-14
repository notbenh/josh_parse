package Parse::SD;
use base qw{Parse};

# disable the method sub lookup 
sub _should_lookup { 0 } 

# all strings that are non-quoted become session lookups
sub _conditional_template{ shift;sprintf q{$session->get('%s')}, shift; }

1;
