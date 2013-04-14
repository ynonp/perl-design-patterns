use strict;
use warnings;
use v5.14;

package My::Test::File;
use Moose;
has 'name', is => 'ro', isa => 'Str';

sub create {
  my ( $self ) = @_;
  warn 'Create File: ', $self->name;
}

sub delete {
  my ( $self ) = @_;
  warn 'Delete File: ', $self->name;
}

package My::Test::Dir;
use Moose;

has 'name', is => 'ro', isa => 'Str';

sub create {
  my ( $self ) = @_;
  warn 'Create Dir: ', $self->name;
}

sub delete {
  my ( $self ) = @_;
  warn 'Delete Dir: ', $self->name;
}

1;
