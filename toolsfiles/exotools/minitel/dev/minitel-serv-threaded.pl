use warnings; 
use strict;

use lib '.';

use IO::Socket::INET;
use threads;
use Minitel;

use Data::Dumper;

my $port_listen = 2808;
our %Env;

$| = 1; # Autoflush


my $socket = IO::Socket::INET->new(

  LocalHost   => '0.0.0.0',
  LocalPort   =>  $port_listen,
  Proto       => 'tcp',
  Listen      =>  5,
  Reuse       =>  1

) or die "Cannot create socket";

print "Waiting for tcp connect to connet on port $port_listen (see echo-client.pl)\n";

while (1) {


    my $client_socket = $socket->accept();

    my $client_address = $client_socket->peerhost;
    my $client_port    = $client_socket->peerport;

    print "$client_address $client_port has connected\n";

    threads -> create(\&connection, $client_socket);

}

$socket -> close;


sub dispatch {
  my ($val ) = @_;

  chomp $val;
  my ($cmd, @args) = split ' ', $val;

  $Env{$cmd} = $args[0];

  my $e = Dumper %Env;
  return ($e, $e);

  qx(tmux select-window -t out:minitel);

   if ($val eq 'update'){
      delete $INC{'Minitel.pm'};
      require Minitel ;
      return ("OK, Code will be updated", "OK, Code will be updated");
   }else{
     #      Minitel::dispatch($val, $Envref);
   }
 }

sub connection {
  my $client_socket = shift;

  while (1) {

    my $data = <$client_socket>;

    return unless $data;
    return if $data eq "";

    my ($resp_serv, $resp_client) = dispatch($data );
    

    print "\033[2J";
    print "\033[0;0H";
    print $resp_serv;

    #print $client_socket "ok \n";
    print $client_socket "$resp_client\n"; 
    #$prev = $data;
  }
}

