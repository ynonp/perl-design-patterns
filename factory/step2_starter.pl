use strict;
use warnings;
use v5.14;

package main;

# My::Test::FS includes two classes:
# My::Test::File and My::Test::Dir
use My::Test::FS;
use My::Win::FS;
use My::Unix::FS;

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
while (<>) {
  my ( $cmd, $arg ) = split;
  next if ! $cmd;
}
