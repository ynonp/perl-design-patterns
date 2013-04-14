use strict;
use warnings;
use v5.14;

use XML::LibXML;

my $doc = XML::LibXML->load_xml(location => "cd_catalog.xml");

my $cd_list = $doc->findnodes('//CD/COUNTRY');

# Using the goatsie to prevent
# perl from concatenating all the values
my $count = () = $cd_list->grep(  sub { $_->textContent eq 'UK' }  );

say "found $count UK artists";
