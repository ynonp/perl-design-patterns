use strict;
use warnings;
use v5.14;

package main;

use My::Test::FS;

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



