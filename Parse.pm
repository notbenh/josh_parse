package Parse;

use strict;
use warnings;
use feature ':5.10';

use Data::Dumper; sub D(@){ warn Dumper @_ };
use Scalar::Util qw{looks_like_number};
use YAML ();

sub new {
  my $class = shift;
  bless {@_}, $class;
}

#sub default {1} # default should always return true
#

# this could be so much better
sub looks_like_op {
  shift =~ m{^(eq|ne|gt|lt|==|!=|>=|>|<=|<|\+|-|\*|/|or|and|\|\||\s|&&|\(+|\)+)$};
}


#
## this too
#sub looks_like_code {
#  shift =~ m{^[()]$};
#}
#
# this too
sub is_quoted {
  shift =~ m{^['"].*['"]$};
}

# ideally takes an arrayref of hashes
# also this is a single pass parse so you will want to quote everything
# if you move to a repeat till fall out pass then you could get away
# with sloppier input
sub parse {
  my $self = shift;
  foreach my $rule ( @{$self->{rules}} ){
    my ( $page, $formula ) = each $rule;

    #foreach (values %$rules){
    #  my $cmd = join ' '
    #          , map{ $self->can($_)        ? $self->$_
    #               : looks_like_number($_) ? $_
    #               : looks_like_op($_)     ? $_
    #               : looks_like_code($_)   ? $_
    #               : is_quoted($_)         ? $_
    #               :                         qq{'$_'}
    #               }
    #            split ' ', $_;
    #  #warn "CMD: $cmd";
    #  # NOTE: should trap warnings here
    #  return $rule->{$_} if eval $cmd;
    #}

    $formula = $self->parse_formula( $formula );
    return $page if eval $formula;
  }
  return undef; 
}

sub parse_formula {
  my ( $self, $formula ) = @_;

  return 1 if $formula eq 'default';

  my @formula_parts = split( /([\d.]+|\b|\s|'[^']+')/, $formula );
  my @evallable_formula;
  for ( @formula_parts ) {
    next unless length; # skip over blank entries from our split
    next if m/^\s+$/; # be a bit more explicit in removing blocks of whitespace
    $_ = '==' if $_ eq '=';

    if ( not looks_like_number( $_ ) and not looks_like_op( $_ ) and not is_quoted( $_ ) ) {
      # must be a slot name
      # TODO look up against the list of slots in the survey
      $_ = "\$session->get('$_')";
    }

    push( @evallable_formula, $_ );
  }

  $formula = join( ' ', @evallable_formula );

  $formula =~ s/== '/eq '/g; # translate == to eq if the value to compare to starts with single quote

  return $formula;
}

sub parse_yaml {
  my $self = shift;
  $self->{rules} = YAML::Load(shift);
  $self->parse;
}

sub parse_yaml_file {
  my $self = shift;
  $self->{rules} = YAML::LoadFile(shift);
  $self->parse;
}

1;
