package Parse;
use strict;
use warnings;
use feature ':5.10';
use Scalar::Util qw{looks_like_number};

sub new {
  my $class = shift;
  return bless {@_}, $class;
  # TODO: possibly store off the actual values as attr
  #bless { #ops  => [qw{eq ne gt lt == != >= > <= < + - * / or || and && \s (+ )+}]
  #      , #code => [qw{( )}]
  #      , #quote=> [qw{' "}]
  #      , @_
  #      }, $class;
}

sub default {1} # default evaluation should always return true

# this could be so much better, is there a global list or can it use an
# attribute so that the user can mod this list after init
sub looks_like_op {
  shift =~ m{^(eq|ne|gt|lt|==|!=|>=|>|<=|<|\+|-|\*|/|or|and|\|\||\s|&&|\(+|\)+)$};
}

# seems that this could be expanded but it is really dependnt on use
sub looks_like_code {
  shift =~ m{^[()]$};
}

# deals with match quotes but should really pull from an attr
sub is_quoted { shift =~ /^(['"]).*\1$/ }


=head2 parse
Take an array of hashrefs (rule pairs) and return the first matching rule(key)

  my $true = $p->parse({false=>0},{true=>1}); #'true'

Each evaluation of the conditional is done by the value being passed to parse_to_eval and then evaled.

=cut

sub parse{
  my $self = shift;
  foreach my $rule_pair (map{@$_}@_){
    my ($rule,$conditional) = each $rule_pair;
    return $rule if eval $self->parse_to_eval($conditional);
  }
  return undef;
}


# how to split up the conditional
sub _conditional_split { shift;split /([\d.]+|\b|\s|'[^']+')/, shift }
# any items from _conditional_split to ignore (white space and empty
# strings by default)
sub _conditional_ignore{ shift;grep{length && ! m/^\s+$/} @_ }
# any forced alterations to make in the conditional (default is to
# change any instance of a single = to == to allow for 5 = 4 to be valid
sub _conditional_alter { shift;map{$_ eq '=' ? '==' : $_} @_ }
# wrap up all _cond_* methods
sub _conditional_parts {
  my $self = shift;
  $self->_conditional_alter(
    $self->_conditional_ignore(
      $self->_conditional_split(@_)
    )
  );
}

# how to decide if a part should be a look up and what to return
sub _should_lookup { shift->can(shift) }
sub _lookup {
  my $self   = shift;
  my $method = shift;
  $self->$method(@_)
}

# a template to define how the final step of the parse to eval tree
# should handle each part
sub _conditional_template{ shift;sprintf q{'%s'}, shift; }

# a hook to allow the compiled eval to be altered before it is actually
# run, by default this will translate == to eq in the case where the
# second value is quoted
sub _eval_translate{
  my $self = shift;
  my $eval = shift;
  $eval =~ s/== '/eq '/g;
  return $eval;
}


=head2 parse_to_eval
Takes a conditional and will return a string that can be evaluated. This is pulled out as it's own sub to allow for a subclass to overwrite this default.
=cut

# TODO: does it make any sense to have the order of this as some config attr?
sub parse_to_eval {
  my $self = shift;
  my $cond = shift;
  # this really should be a map as this is what they do
  my @parts;
  for my $part ($self->_conditional_parts($cond)){
    if(  looks_like_number($part)
      || looks_like_op($part)
      || is_quoted($part)
      ){ # passthru
      push @parts, $part;
    }
    elsif( $self->_should_lookup($part)){
      push @parts, $self->_lookup($part);
    }
    else {
      push @parts, $self->_conditional_template($part);
    }
  }
  return $self->_eval_translate(join ' ', @parts);
}

1;
