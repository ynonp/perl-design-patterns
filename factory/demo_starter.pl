use strict;
use warnings;
use v5.14;

package main;

# My::Test::FS includes two classes:
# My::Test::File and My::Test::Dir
use My::Test::FS;

# In the following loop, read the input data
# and use file/dir classes to perform the actions
# Each input line is of the form "command args"
# Available Actions:
#   f name: Create a My::Test::File object with the given name
#           and call its ->create method
#   d name: Create a My::Test::Dir object with the given name
#           and call its ->create method
#
#   !f name: Create a My::Test::File object with the given name
#           and call its ->delete method
#
#   !d name: Create a My::Test::Dir object with the given name
#           and call its ->delete method
#
while (<>) {
  my ( $cmd, $arg ) = split;
  next if ! $cmd;

}
