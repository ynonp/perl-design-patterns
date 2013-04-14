use strict;
use warnings;
use v5.14;

use My::FSFactory;

package My::Test::Factory;
use Moose;
with 'My::FSFactory';

sub create_file { shift; My::Test::File->new( @_ ) }
sub create_dir  { shift; My::Test::Dir->new( @_ )  }

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
