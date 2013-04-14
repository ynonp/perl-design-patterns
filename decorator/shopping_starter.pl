use strict;
use warnings;
use v5.14;

package ShoppingCart;
use Moose;

has 'products',
  is => 'rw',
  isa => 'ArrayRef[Product]',
  traits => [qw/Array/],
  handles => {
    add => 'push',
};

sub price {
  my ( $self ) = @_;
  my $total = 0;

  foreach my $product (@{ $self->products } ) {
    $total += $product->price;
  }
  return $total;
}

package Product;
use Moose::Role;

requires 'price';

package main;

my $book1 = Book->new( name => 'foo', price => 15 );
my $book2 = Book->new( name => 'bar', price => 25 );
my $book3 = Book->new( name => 'buz', price => 20 );

my $jimmys_cart = ShoppingCart->new;
my $toms_cart   = ShoppingCart->new;

$jimmys_cart->add( $book1, $book2 );
$toms_cart->add( $book1, $book3 );

say $jimmys_cart->price;
say $toms_cart->price;

