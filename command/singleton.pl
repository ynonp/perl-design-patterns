use strict;
use warnings;
use v5.14;

package S;
use Moose;
use MooseX::Singleton;

has 'x', is => 'rw';
sub hi { warn "Hi" }

package T;
use Moose;

extends 'S';

package main;

my $t1 = T->new;
my $t2 = T->new;
my $t3 = T->new;
my $s1 = S->new;
my $s2 = S->new;

$t1->x(10);
$s1->x(15);

use Data::Printer;

p $t2;
p $t3;
p $t1;

p $s1;
p $s2;
