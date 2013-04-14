use strict;
use warnings;
use v5.14;

package My::Win::Factory;
use Moose;
with 'My::FSFactory';

sub create_file { shift; My::Win::File->new( @_ ) }
sub create_dir  { shift; My::Win::Dir->new( @_ )  }

package My::Win::File;
use Moose;

has 'name', is => 'ro', isa => 'Str';

sub create { warn "My::Win::File create" }

sub delete { warn "My::Win::File delete" }

package My::Win::Dir;
use Moose;

has 'name', is => 'ro', isa => 'Str';
sub create { warn "My::Win::Dir create" }
sub delete { warn "My::Win::Dir delete" }

1;
