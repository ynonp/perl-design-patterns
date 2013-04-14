use strict;
use warnings;
use v5.14;

package HeavyBuilder;
use Moose;
with 'MooseX::Clone';

has 'fib',
      is => 'rw',
      isa => 'ArrayRef[Int]',
      builder => '_build_fib',
      traits => [qw/Clone/];

sub _build_fib {
  my @result = (1, 1);

  for ( 1..20 ) {
    push @result, $result[-1] + $result[-2];
  }

  return \@result;
}


package main;
my $f = HeavyBuilder->new;
my $g = $f->clone;
my $h = $f->clone;

push $f->fib, 'a';

