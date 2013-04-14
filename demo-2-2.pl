use strict;
use warnings;
use v5.14;

package Plane;
use Moose;

has 'assigned_engineers' => (
 is       => 'ro',
 isa      => 'ArrayRef[Engineer]',
 required => 1,
);

has 'auto_pilot' => (
  is  => 'ro',
  isa => 'AutoPilot',
  default => sub { SafeAutoPilot->new },
  init_arg => undef,
);

package AutoPilot;
use Moose::Role;

package SafeAutoPilot;
use Moose;
with 'AutoPilot';

package CrazyAutoPilot;
use Moose;
with 'AutoPilot';

package main;
use Data::Printer;

my $p = Plane->new(  auto_pilot => CrazyAutoPilot->new, assigned_engineers => [] );
p $p;

