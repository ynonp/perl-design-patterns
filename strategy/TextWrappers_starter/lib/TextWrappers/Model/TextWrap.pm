package TextWrappers::Model::TextWrap;
use Moose;
use namespace::autoclean;

extends 'Catalyst::Model';

use Text::Wrap;

has 'algorithm', is => 'rw', isa => 'Str', default => 'Text::Wrap';

sub wrap_text {
  my ( $self, $text, $columns ) = @_;

  $columns ||= 40;
  $Text::Wrap::columns = $columns;

  wrap( "\t", "", $text );
}


__PACKAGE__->meta->make_immutable;

1;
