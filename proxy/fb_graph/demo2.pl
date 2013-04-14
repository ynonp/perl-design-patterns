use strict;
use warnings;
use v5.14;
use LWP::Simple;
use JSON;

my $token =
'BAACEdEose0cBAP9rh0Cj766xRFLZCZADki9xLrdCKSlfLMhuoYzXvudY583uWuCVRPuTc6HqXDsbdc3GSmflrNTHrZCZAcjZBP75T0pZB7147PscVHUJnNbAYRkha0QPzL879wGNobQuD4Uoqo121R8oJDZB0ZCdE9opuW4vZBcf7UobIahZBQ8rWI4U1voOWf53Omrk8gAktxJAZDZD';

my $res = get
"https://graph.facebook.com/me?access_token=$token";

my $info = from_json( $res );

say $info->{name};
