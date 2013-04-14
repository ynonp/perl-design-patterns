package TextWrappers::Controller::TextWrap;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

sub wrap :Local :Args(0) {
  my ( $self, $c ) = @_;
  my $text    = $c->req->param('text');
  my $columns = $c->req->param('columns') || 40;
  my $algorithm = $c->req->param('algorithm');

  $c->model->algorithm( $algorithm ) if $algorithm;

  my $result = $c->model->wrap_text( $text, $columns );

  $c->res->content_type('text/plain');
  $c->res->body( $result );
}

1;
