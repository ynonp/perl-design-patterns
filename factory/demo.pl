use strict;
use warnings;
use v5.14;

package main;

use My::FSFactory;

use My::Test::FS;
use My::Win::FS;
use My::Unix::FS;

package SingleFactory;
use Moose;
use MooseX::Singleton;

has 'factory',
    is => 'ro',
    isa => 'My::FSFactory',
    handles => [qw/create_file create_dir/],
    lazy_build => 1;

sub _build_factory {
  return My::Test::Factory->new if $ENV{DEBUG};
  return My::Win::Factory->new if $^O =~ /Win/;
  return My::Unix::Factory->new if $^O =~ /linux|darwin/;

  die "Unknown OS";
}

package Factory;
use Moose;

has '_pkg', is => 'ro', isa => 'Str', builder => '_build__pkg';
has '_file_cls', is => 'ro', isa => 'Str', lazy_build => 1;
has '_dir_cls', is => 'ro', isa => 'Str', lazy_build => 1;

sub _build__pkg {
  return "My::Test" if $ENV{DEBUG};
  return "My::Win"  if $^O =~ /Win/;
  return "My::Unix" if $^O =~ /darwin|linux/;

  die "Don't know what to create";
}

sub _build__file_cls { shift->_pkg . "::File" }
sub _build__dir_cls  { shift->_pkg . "::Dir"  }

sub create_file { shift->_file_cls->new( @_ ) }
sub create_dir  { shift->_dir_cls->new( @_ )  }

# In addition to the instructions below, the File/Dir objects used
# should be determined according to the following
#
# If a DEBUG environment variable is defined with a true value
# -> use My::Test::File and My::Test::Dir
#
# Else: If we're on windows
# -> use My::Win::File and My::Win::Dir
#
# Else: If we're on unix
# -> use My::Unix::File and My::Unix::Dir
#
# Else abort in panic
#
#####################
# In the following loop, read the input data
# and use file/dir classes to perform the actions
# Each input line is of the form "command args"
# Available Actions:
#   f name: Create a File object with the given name
#           and call its ->create method
#   d name: Create a Dir object with the given name
#           and call its ->create method
#
#   !f name: Create a File object with the given name
#           and call its ->delete method
#
#   !d name: Create a Dir object with the given name
#           and call its ->delete method
#

my $factory = SingleFactory->new;

my %command = (
  'f' => sub  { $factory->create_file( name => @_)->create },
  '!f' => sub { $factory->create_file( name => @_)->delete },

  'd'  => sub { $factory->create_dir( name => @_)->create  },
  '!d' => sub { $factory->create_dir( name => @_)->delete  },
);

while (<>) {
  my ( $cmd, $arg ) = split;
  next if ! $cmd;
  next if ! $command{$cmd};

  $command{$cmd}->($arg);
}



