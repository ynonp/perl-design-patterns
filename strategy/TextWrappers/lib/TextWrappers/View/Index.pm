package TextWrappers::View::Index;
use Moose;
use namespace::autoclean;

extends 'Catalyst::View::TT';

__PACKAGE__->config(
    TEMPLATE_EXTENSION => '.tt',
    render_die => 1,
);

=head1 NAME

TextWrappers::View::Index - TT View for TextWrappers

=head1 DESCRIPTION

TT View for TextWrappers.

=head1 SEE ALSO

L<TextWrappers>

=head1 AUTHOR

Ynon Perek

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
