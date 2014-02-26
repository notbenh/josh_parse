package Parse;
use strict;
use warnings;
use Data::Dumper; sub D(@){ warn Dumper @_ };
use Scalar::Util qw{looks_like_number};
use YAML ();

sub new {
  my $class = shift;
  bless {@_}, $class;
}

sub default {1} # default should always return true

# this could be so much better
sub looks_like_op {
  shift =~ m{^(?:eq|ne|gt|lt|==|!=|>=|>|<=|<|\+|-|\*|/|or|and|\|\||&&)$};
}

# this too
sub looks_like_code {
  shift =~ m{^[()]$};
}

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
  foreach my $data ( map{ref($_) eq 'ARRAY' ? @$_ : $_ } @_ ? @_ : @{$self->{data}} ){
    foreach (keys %$data){
      my $cmd = join ' '
              , map{ $self->can($_)        ? $self->$_
                   : looks_like_number($_) ? $_
                   : looks_like_op($_)     ? $_
                   : looks_like_code($_)   ? $_
                   : is_quoted($_)         ? $_
                   :                         qq{'$_'}
                   }
                split ' ', $_;
      #warn "CMD: $cmd";
      # NOTE: should trap warnings here
      return $data->{$_} if eval $cmd;
    }
  }
  return undef; 
}

sub parse_yaml {
  my $self = shift;
  $self->{data} = YAML::Load(shift);
  $self->parse;
}

sub parse_yaml_file {
  my $self = shift;
  $self->{data} = YAML::LoadFile(shift);
  $self->parse
}

1;
