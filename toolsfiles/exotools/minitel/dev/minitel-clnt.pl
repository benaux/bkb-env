use IO::Socket::INET;

use strict;
use warnings;
 
# auto-flush on socket
$| = 1;
 
# create a connecting socket
my $socket = new IO::Socket::INET (
    PeerHost => 'localhost',
    PeerPort => '7777',
    Proto => 'tcp',
);
die "cannot connect to the server $!\n" unless $socket;
 
sub sendit {
# data to send to a server
  my $req = @_; 

  $req = <STDIN> unless $req;

  my $size = $socket->send($req);
   
# notify server that request has been sent
    shutdown($socket, 1);
   
# receive a response of up to 1024 characters from server
    my $response = "";
    $socket->recv($response, 1024);
    chomp $response;
    print "received response: $response\n";
    print "\033[2J";
    print "\033[0;0H";
    print "\n";
    print $response . "\n";
     #print "\n------------\n";
     sendit() unless $response;
}

sendit(@ARGV);
$socket->close();
