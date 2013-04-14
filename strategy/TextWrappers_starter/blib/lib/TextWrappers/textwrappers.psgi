use strict;
use warnings;

use TextWrappers;

my $app = TextWrappers->apply_default_middlewares(TextWrappers->psgi_app);
$app;

