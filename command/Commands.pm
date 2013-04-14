use strict;
use warnings;
use v5.14;

package Invoker;
use Moose;
use Try::Tiny;

has 'past_commands', is => 'rw', isa => 'ArrayRef[Command]', 
                    traits => ['Array'], default => sub { [] };

sub call {
  my ( $self, $cmd ) = @_;
  push $self->past_commands, $cmd ;
  try {
    $cmd->execute;
  } catch {
    $self->rollback;
  }
}

sub check {
  my ( $self ) = @_;
  $self->past_commands([]);
}

sub rollback {
  my ( $self ) = @_;
  while ( my $next = pop $self->past_commands ) {
    $next->undo;
  }
}

package Command;
use Moose::Role;

requires qw/execute undo/;

package Cmd::Save;
use Moose;

has 'invoker', is => 'ro', required => 1, handles => { execute =>
  'check'};

sub undo {}

with 'Command';

package Cmd::FailCmd;
use Moose;

sub execute { die "Fail" }
sub undo {}

with 'Command';

package Cmd::CreateFile;
use Moose;

has 'file', is => 'ro', required => 1, handles => 
    { execute => 'create', undo => 'delete' };

with 'Command';

package Cmd::DeleteFile;
use Moose;

has 'file', is => 'ro', required => 1, handles => 
    { execute => 'delete', undo => 'create' };

with 'Command';

package Cmd::CreateDir;
use Moose;

has 'dir', is => 'ro', required => 1, handles => 
    { execute => 'create', undo => 'delete' };

with 'Command';

package Cmd::DeleteDir;
use Moose;

has 'dir', is => 'ro', required => 1, handles => 
    { execute => 'delete', undo => 'create' };

with 'Command';

