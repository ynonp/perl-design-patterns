use strict;
use warnings;
use v5.14;

package Test;
use Moose::Role;

has 'skip', is => 'rw', isa => 'Bool', default => 0;

package TestA;
use Moose;
with 'Test';

has 'x', is => 'ro', isa => 'Int', required => 1;
has 'y', is => 'ro', isa => 'Int', required => 1;

# Succeed if x + y > 10
sub run {
  my ( $self ) = @_;

  if ( $self->x + $self->y > 10 ) {
    # success
  } else {
    # fail
  }
}

package TestB;
use Moose;
with 'Test';

has 'z', is => 'ro', isa => 'Int', required => 1;

# Succeed if z % 2 == 0
sub run {
  my ( $self ) = @_;
  if ( $self->z % 2 == 0 ) {
    # success
  } else {
    # fail
  }
}

package TestC;
use Moose;
with 'Test';

has 'o', is => 'ro', isa => 'Int', required => 1;
has 'w', is => 'ro', isa => 'Int', required => 1;

# Succeed if w / o is an Integer
sub run {
  my ( $self ) = @_;

  if ( int ( $self->w / $self->o ) == $self->w / $self->o ) {
    # success
  } else {
    # fail
  }
}

package main;

my $tests = { A => [], B => [], C => [] };
push $tests->{A}, TestA->new( x => 2, y => 5 );
push $tests->{A}, TestA->new( x => 8, y => 2 );
push $tests->{A}, TestA->new( x => 5, y => 22 );
push $tests->{A}, TestA->new( x => 21, y => 1 );
push $tests->{A}, TestA->new( x => 2, y => 2 );

push $tests->{B}, TestB->new( z => 7 );
push $tests->{B}, TestB->new( z => 4 );
push $tests->{B}, TestB->new( z => 22 );
push $tests->{B}, TestB->new( z => 11 );

push $tests->{C}, TestC->new( o => 2, w => 44 );
push $tests->{C}, TestC->new( o => 6, w => 20 );
push $tests->{C}, TestC->new( o => 8, w => 30 );
push $tests->{C}, TestC->new( o => 4, w => 44 );
push $tests->{C}, TestC->new( o => 6, w => 55 );

sub init_tests {
}

#########################
# Rules for skipping tests
#
# If a TestA fails:
#   Skip all TestB for which: x + y = z
#   Skip all TestC for which: o * w = x * y
#
# If a TestB fails:
#   Skip all TestC for which: w / o = z
#

init_tests;

my $skipped = 0;
foreach my $test ( @{$tests->{A}}, @{$tests->{B}}, @{$tests->{C}} ) {
  if ( $test->skip() ) {
    $skipped += 1;
    next;
  }

  $test->run();
}

# now $skipped == 3

say "Skipped $skipped tests. Expected to skip 3";


