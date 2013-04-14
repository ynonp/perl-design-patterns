use strict;
use warnings;
use v5.14;

use Math::Symbolic;

my $left  = Math::Symbolic::Operator->new('+', 5, 7);
my $right = Math::Symbolic::Operator->new('*', 2, 2);
my $sum   = Math::Symbolic::Operator->new( '+', $left, $right );

say $sum->value;
