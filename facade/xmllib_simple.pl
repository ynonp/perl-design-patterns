use strict;
use warnings;
use v5.14;

use XML::LibXML::Simple qw/XMLin/;

my $xml = XMLin 'cd_catalog.xml';

# Now $xml is a hash with all the data
# from cd_catalog.xml

my $count = grep { $_->{COUNTRY} eq 'UK' } @{ $xml->{CD} };

say "found $count UK artists";

