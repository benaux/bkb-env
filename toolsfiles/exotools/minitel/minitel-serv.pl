#!/usr/bin/perl -w
use strict;
use warnings;

use IO::Socket;
use Net::hostent;              # for OO version of gethostbyaddr

use lib '.';
#use Minitel;

use Data::Dumper;

our $KV = {};

our $PORT = 5555;                  # pick something not in use
our $server = IO::Socket::INET->new( Proto     => 'tcp',
                                  LocalPort => $PORT,
                                  Listen    => SOMAXCONN,
                                  Reuse     => 1);

die "can't setup server" unless $server;
print "[Server $0 accepting clients]\n";
while (my $client = $server->accept()) {
   $client->autoflush(1);
   #print $client "Welcome to $0; type help for command list.\n";
   my $hostinfo = gethostbyaddr($client->peeraddr);
   printf "[Connect from %s]\n", $hostinfo->name || $client->peerhost;
   #print $client "Command? ";
   while (my $data =  <$client>) {
      my ($cmd, @args) = split ' ', $data;
      next unless $cmd;
      my ($serv_resp, $client_resp);
      if ($cmd eq 'update'){
         delete $INC{'Minitel.pm'};
         ($serv_resp, $client_resp) = 
            ("Ok, code updated", "");
      }else{
         require Minitel;
         ($serv_resp, $client_resp) = Minitel::dispatch ($KV, $cmd, \@args);
      }
      if($serv_resp){
         print "\033[2J";
         print "\033[0;0H";
         print $serv_resp . "\n";
      }
      print $client (($client_resp) ? $client_resp : "") . "\n";

   } #continue {
      #      print $client "Commandxxxx? \n";
      #}
   close $client;
}
