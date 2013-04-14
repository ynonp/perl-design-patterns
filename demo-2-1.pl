use strict;
use warnings;
use v5.14;

package MoneyRates;
use Moose;

has '_rate', is => 'ro', isa => 'Num', lazy_build => 1, reader => 'rate';

sub _build__rate { 3.7 }

sub toNis    { $_[0] * shift->rate }
sub toDollar { $_[0] / shift->rate }

package Shop;
use Moose;

has 'rates',
  is => 'ro', isa => 'MoneyConverter', lazy_build => 1;

sub _build_rates { OnlineMoneyConverter->new }

package main;
use Data::Printer;
my $book = Book->new( price => 27);
my $cart = Cart->new( book => $book );
$cart->applyDiscount;

p $book;
