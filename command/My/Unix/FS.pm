use strict;
use warnings;
use v5.14;

package My::Unix::Factory;
use Moose;
with 'My::FSFactory';

sub create_file { shift; My::Unix::File->new( @_ ) }
sub create_dir  { shift; My::Unix::Dir->new( @_ )  }

package My::Unix::File;
use Moose;

has 'name', is => 'ro', isa => 'Str';

sub create { warn "My::Unix::File create" }

sub delete { warn "My::Unix::File delete" }

package My::Unix::Dir;
use Moose;

has 'name', is => 'ro', isa => 'Str';
sub create { warn "My::Unix::Dir create" }
sub delete { warn "My::Unix::Dir delete" }

1;
