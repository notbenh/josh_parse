#!/usr/bin/perl
use strict;
use warnings;

while(<DATA>){
  chomp;
  print qq{\nLINE: $_};
  print qq{  has only one =} if m/[^<=>!]=[^=]/;
  # or if you wanna sub it:
#  print qq{  has be fixed to have a = translated to ==\n  NOW: $_}
#     if s/([^<=>!])(=)([^=])/$1$2$2$3/g;
}



__END__
this = that
this= that
this =that
this=that
this == that
this== that
this ==that
this==that
this < that

