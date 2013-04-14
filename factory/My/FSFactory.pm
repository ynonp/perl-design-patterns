use strict;
use warnings;
use v5.14;

package My::FSFactory;
use Moose::Role;

requires 'create_file';
requires 'create_dir';

1;
