use strict;
use warnings;
use v5.14;

package SoftwareLicense;
use Moose;

has 'product', is => 'ro', isa => 'Str';

sub can_i_use {
  my ( $self, $product ) = @_;

  return $self->product eq lc( $product );
}

package LicenseBundle;
use Moose;

has 'licenses', 
  is => 'ro', 
  isa => 'ArrayRef[SoftwareLicense]', 
  required => 1;

package main;
use YAML::Tiny;

sub build_licenses {
}

sub check_license {
}

my $yml = YAML::Tiny->read('demo2.yml') or die YAML::Tiny->errstr;
my $data_ref = shift @$yml;
my $product  = shift @ARGV;

build_licenses( $data_ref );
check_license( $product ) or die "No license found for: $product";

say "License Found";
