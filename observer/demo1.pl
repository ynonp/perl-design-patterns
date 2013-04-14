use v5.14;

package Observable;
use Moose::Role;
use Scalar::Util qw/refaddr/;

has 'observers',
    is => 'rw',
    isa => 'ArrayRef[Observer]',
    traits => ['Array'],
    handles => {
      attach => 'push',
    };

sub detach {
  my ( $self, $observer ) = @_;
  $self->observers ( grep { refaddr($_ ) != refaddr( $observer ) }
                          @{ $self->observers } );
}

sub notify {
  my ( $self ) = @_;
  $_->update($self) for @{ $self->observers };
}

requires 'state';

################################################################################
################################################################################

package Observer;
use Moose::Role;

requires 'update';

################################################################################
################################################################################

package Reporter;
use Moose;
with 'Observer';

sub update {
  my ( $self, $test ) = @_;
  if ( $test->state->{success} ) {
    $self->success();
  } else {
    $self->fail();
  }
}

sub success {
  say "Bravo ! test passed";
}

sub fail {
  say "Sorry, test failed...";
}

################################################################################
################################################################################

package TestsCounter;
use Moose;
with 'Observer';

has 'success_count',
  is => 'rw',
  isa => 'Num',
  traits => ['Counter'],
  default => 0,
  handles => {
    success => 'inc',
  };

sub update {
  my ( $self, $test ) = @_;
  if ( $test->state->{success} ) {
    $self->success();
  }
}


################################################################################
################################################################################

package Mediator;
use Moose;
with 'Observer';

has 'tests', is => 'ro', isa => 'HashRef', required => 1;

sub update {
  my ( $self, $test ) = @_;

  return if $test->state->{success};

  given ( $test ) {
    $self->report_fail_a($_) when ( $_->isa('TestA') );
    $self->report_fail_b($_) when ( $_->isa('TestB') );
    $self->report_fail_c($_) when ( $_->isa('TestC') );
  }
}

# If a TestA fails:
#   Skip all TestB for which: x + y = z
#   Skip all TestC for which: o * w = x * y
sub report_fail_a {
  my ( $self, $failed_test ) = @_;
  use Data::Printer;
  warn 'FAIL: ', p ( $failed_test );

  $_->skip(1) for
    grep { $failed_test->x + $failed_test->y == $_->z }
        @{ $self->tests->{B} };

  $_->skip(1) for
    grep { $failed_test->x * $failed_test->y == $_->o * $_->w }
        @{ $self->tests->{C} };

}

# If a TestB fails:
#   Skip all TestC for which: w / o = z
sub report_fail_b {
  my ( $self, $failed_test ) = @_;

  $_->skip(1) for
    grep { $_->w / $_->o == $failed_test->z }
         @{ $self->tests->{C} };

}

sub report_fail_c {}

################################################################################
################################################################################

package Test;
use Moose::Role;

has 'mediator', is => 'rw';
has 'skip', is => 'rw', isa => 'Bool', default => 0;
has 'state', is => 'rw', isa => 'HashRef', default => sub { {} };


requires 'run';

after 'run' => sub {
  my ( $self ) = @_;
  $self->notify;
};

################################################################################
################################################################################

package TestA;
use Moose;
with 'Test';
with 'Observable';

has 'x', is => 'ro', isa => 'Int', required => 1;
has 'y', is => 'ro', isa => 'Int', required => 1;

# Succeed if x + y > 10
sub run {
  my ( $self ) = @_;
  $self->state->{success} = $self->x + $self->y > 10;
}

################################################################################
################################################################################

package TestB;
use Moose;
with 'Test';
with 'Observable';

has 'z', is => 'ro', isa => 'Int', required => 1;

# Succeed if z % 2 == 0
sub run {
  my ( $self ) = @_;
  $self->state->{success} = $self->z % 2 == 0;
}

################################################################################
################################################################################

package TestC;
use Moose;
with 'Test';
with 'Observable';

has 'o', is => 'ro', isa => 'Int', required => 1;
has 'w', is => 'ro', isa => 'Int', required => 1;

# Succeed if w / o is an Integer
sub run {
  my ( $self ) = @_;
  $self->state->{success} = int( $self->w / $self->o  ) == $self->w / $self->o;
}
################################################################################
################################################################################

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

my $mediator = Mediator->new( tests => $tests );
my $reporter = Reporter->new;
my $counter  = TestsCounter->new;


my $skipped = 0;

foreach my $test ( @{$tests->{A}}, @{$tests->{B}}, @{$tests->{C}} ) {
  $test->attach( $mediator, $reporter, $counter );

  if ( $test->skip() ) {
    $skipped += 1;
    next;
  }

  $test->run();
}

# now $skipped == 3

say "Skipped $skipped tests. Expected to skip 3";


