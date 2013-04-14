use strict;
use warnings;
use v5.14;

package My::Facebook;
use Moose;
with 'Role::REST::Client';

has 'access_token', is => 'ro', required => 1;

sub name {
  my ( $self ) = @_;

  my $res = $self->get(
    '/me',
    { access_token => $self->access_token },
    { deserializer => 'application/json'}
  );

  die $res->data if $res->code != 200;

  my $info = $res->data;
  return $info->{name};
}

package main;
my $fb = My::Facebook->new(
  server => 'https://graph.facebook.com',
  type => 'application/json',
  access_token => 'AAACEdEose0cBAOZB2olmXrj0SGN8AUfoc0Gi3gw95f8JhQvPGTv0cZBijLIBlOckyKGfZCsJ1IimguaYDVott2o95x60iCPlqIQ1NvQ1AZDZD',
);

say $fb->name;
