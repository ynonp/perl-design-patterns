package TextWrappers::Model::TextWrap;
use Moose;
use namespace::autoclean;

use Try::Tiny;
use Text::Wrap;
use Text::Wrapper;
use Text::ASCIITable::Wrap;

extends 'Catalyst::Model';

has '_algorithm',
  is => 'rw',
  isa => 'TW::Algorithm',
  default => sub { TW::Algorithm::Wrap->new };

sub algorithm {
  my ( $self, $algorithm ) = @_;

  try {
    $self->_algorithm( "TW::Algorithm::$algorithm"->new );
  } catch {
    $self->_algorithm( TW::Algorithm::Wrap->new );
  };
}

sub wrap_text {
  my ( $self, $text, $columns ) = @_;

  $columns ||= 40;
  $self->_algorithm->set_columns( $columns );
  $self->_algorithm->wrap( $text );
}


__PACKAGE__->meta->make_immutable;

package TW::Algorithm;
use Moose::Role;

requires 'wrap';
requires 'set_columns';

package TW::Algorithm::Wrap;
use Moose;
with 'TW::Algorithm';

sub set_columns {
  my ( $self, $columns ) = @_;
  $Text::Wrap::columns = $columns;
}

sub wrap {
  my ( $self, $text ) = @_;
  Text::Wrap::wrap("\t", "", $text);
}


package TW::Algorithm::ASCIITable::Wrap;
use Moose;

has 'columns',
    is => 'rw',
    isa => 'Num',
    writer => 'set_columns',
    default => 40;

sub wrap {
  my ( $self, $text ) = @_;
  Text::ASCIITable::Wrap::wrap( $text, $self->columns );
}

with 'TW::Algorithm';

package TW::Algorithm::Wrapper;
use Moose;

has 'wrapper', is => 'ro', lazy_build => 1,
    handles => { set_columns => 'columns' };

sub _build_wrapper { Text::Wrapper->new }

sub wrap {
  my ( $self, $text ) = @_;
  $self->wrapper->wrap( $text );
}

with 'TW::Algorithm';
1;
