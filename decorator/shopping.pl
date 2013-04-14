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
    add            => 'push',
};

sub apply_discount {
  my ( $self, $discount ) = @_;
  $self->products(
    [ map { $discount->new( product => $_) }
        @{ $self->products } ]
  );
}


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

package Book;
use Moose;

has 'price', is => 'ro', isa => 'Num', required => 1;
has 'name', is => 'ro', isa => 'Str', required => 1;

with 'Product';

package ReadersClubDiscount;
use Moose;

has 'book', is => 'ro', isa => 'Book', required => 1;

sub price {
  my ( $self ) = @_;
  return $self->book->price * 0.9;
}

with 'Product';

package TopBuyerDiscount;
use Moose;
with 'Product';

has 'product', is => 'ro', isa => 'Product', required => 1;

sub price {
  my ( $self ) = @_;
  return $self->product->price * 0.5;
}

package main;

my $cart = ShoppingCart->new;
my $book1 = ReadersClubDiscount->new(
              book =>  Book->new( name => 'foo', price => 15 ) );

my $book2 = Book->new( name => 'bar', price => 25 );

$cart->add( $book1, $book2 );

$cart->apply_discount( 'TopBuyerDiscount' );

use Data::Printer;
p $cart;
say $cart->price;

