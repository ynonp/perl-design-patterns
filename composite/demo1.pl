use strict;
use warnings;
use v5.14;


package FS::Entity;
use Moose::Role;

package FS::Dir;
use Moose;
use autodie;
use List::Util qw/sum/;

with 'FS::Entity';

has 'files', 
  is => 'ro', 
  isa => 'ArrayRef[FS::Entity]', 
  lazy_build => 1;

has 'path', is => 'ro', isa => 'Str', required => 1;

sub size { 
  my $self = shift;
  my @files = @{ $self->files };

  if ( @files ) {
    return sum( map { $_->size } @files );
  } else {
    return 0;
  }
}

sub _build_files {
  my $self = shift;

  opendir( my $dh, $self->path );
  my @files;

  while ( readdir $dh ) {
    next if /^[.]+$/;
    my $path = $self->path . "/$_";

    my $e = ( -f $path ) ? FS::File->new( path => $path )
          : ( -d $path ) ? FS::Dir->new(  path => $path )
          : next;
            
    push @files, $e;
  }

  closedir( $dh );

  return \@files;
}

package FS::File;
use Moose;

with 'FS::Entity';
has 'path', is => 'ro', isa => 'Str', required => 1;

sub size { -s shift->path }

package main;
use strict;
use warnings;
use v5.14;

my $fs = FS::Dir->new( path => '.');
say $fs->size;

