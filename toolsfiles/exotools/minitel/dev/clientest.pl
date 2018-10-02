#!/usr/bin/perl -w
# Filename : client.pl

use strict;
use Socket;

# initialize host and port
my $host = shift || 'localhost';
my $port = shift || 5000;
my $server = "localhost";  # Host IP running the server

# create the socket, connect to the port
my $socket;
socket($socket,PF_INET,SOCK_STREAM,(getprotobyname('tcp'))[2])
   or die "Can't create a socket $!\n";
connect( $socket, pack_sockaddr_in($port, inet_aton($server)))
   or die "Can't connect to port $port! \n";

my $line;
while ($line = <$socket>) {
   print "$line\n";
}
close $socket or die "close: $!";
