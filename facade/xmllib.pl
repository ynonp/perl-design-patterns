use strict;
use warnings;
use v5.14;

use XML::LibXML;

my $doc = XML::LibXML->load_xml(location => "cd_catalog.xml");

my @CDs = $doc->getElementsByTagName('CD');

my $count = 0;

foreach my $cd ( @CDs ) {
  my @country_el = $cd->getElementsByTagName('COUNTRY');
  my $country = shift @country_el;
  $count   += 1 if $country->textContent eq 'UK';
}

say "found $count UK artists";
