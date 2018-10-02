#!/usr/bin/perl -w
# chat_server.pl
use strict;
use IO::Socket::INET;

#use local '.';
use lib '.';
use Minitel;

# auto-flush on socket
$| = 1;
 
# creating a listening socket
my $socket = new IO::Socket::INET (
    LocalHost => 'localhost',
    LocalPort => '7777',
    Proto => 'tcp',
    Listen => 5,
    Reuse => 1
);
die "cannot create socket $!\n" unless $socket;
print "server waiting for client connection on port 7777\n";

our $KV = {
  vars => {},
  hist => [],
};

sub proc_req {
	my ($data) = @_;

	my ($action, @args) = split(" ", $data);

  qx(tmux select-window -t out:minitel);

   my $resp = "-";
   if($action){
      if ($action eq 'update'){
         delete $INC{'Minitel.pm'};
         require Minitel ;
         return ("OK, Code will be updated", "");
      }else{
         return Minitel::dispatch($KV, $action, \@args );
      }
    }else{
      return ("no action", "no action")
    }
}

 
while(1) {
	my $client_socket = $socket->accept();
#     my $client_address = $client_socket->peerhost();
#         my $client_port = $client_socket->peerport();
	my $data = "";
	$client_socket->recv($data, 1024);
	my ($serv_resp, $client_resp) = proc_req($data);

  #  print '---------';
  print $serv_resp;
  #print "response: $serv_resp\n";
	 
	$client_socket->send($client_resp);
	 
	shutdown($client_socket, 1);
}
 
$socket->close();
