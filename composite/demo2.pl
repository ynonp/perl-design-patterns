use strict;
use warnings;
use v5.14;

package SoftwareLicense;
use Moose::Role;

requires 'can_i_use';

package SingleLicense;
use Moose;
with 'SoftwareLicense';

has 'product', is => 'ro', isa => 'Str';

sub can_i_use {
  my ( $self, $product ) = @_;

  return $self->product eq lc( $product );
}

package LicenseBundle;
use Moose;
use List::MoreUtils qw/any/;

with 'SoftwareLicense';

has 'licenses', 
  is => 'ro', 
  isa => 'ArrayRef[SoftwareLicense]',
  lazy_build => 1;

has 'data',
  is => 'ro',
  isa => 'ArrayRef',
  required => 1;

sub can_i_use {
  my ( $self, $product ) = @_;

  any { $_->can_i_use( $product ) } @{ $self->licenses };
}

sub _build_licenses {
  my $self = shift;

  [ 
    map { 
      ref($_) ? LicenseBundle->new( data => $_ )
              : SingleLicense->new( product => lc( $_  ) )
    } @{ $self->data } 
  ]

}

package main;
use YAML::Tiny;
my $bundle;

sub build_licenses {
  $bundle = LicenseBundle->new( data => @_ );
}

sub check_license {
  $bundle->can_i_use( @_ );
}

my $yml = YAML::Tiny->read('demo2.yml') or die YAML::Tiny->errstr;
my $data_ref = shift @$yml;
my $product  = shift @ARGV;

build_licenses( $data_ref );
check_license( $product ) or die "No license found for: $product";

say "License Found";

