#!/usr/bin/perl -w
use strict;
use IO::Socket;
my ($host, $port, $kidpid, $handle, $line);
#unless (@ARGV == 2) { die "usage: $0 host port" }

($host, $port) = ('localhost', 5555);

qx(tmux select-window -t out:minitel);

sub readkey {
   open(my $tty, "+</dev/tty") or die "no tty: $!";
   system "stty  cbreak </dev/tty >/dev/tty 2>&1";
   my $key = getc($tty);       # perhaps this works
   close $tty;
   return $key;
}


# create a tcp connection to the specified host and port
$handle = IO::Socket::INET->new(Proto     => "tcp",
																PeerAddr  => $host,
																PeerPort  => $port)
			 or die "can't connect to port $port on $host: $!";


$handle->autoflush(1);              # so output gets there right away
#print STDERR "[Connected to $host:$port]\n";
# split the program into two processes, identical twins
die "can't fork: $!" unless defined($kidpid = fork());
# the if{} block runs only in the parent process
if ($kidpid) {
		# copy the socket to standard output
		while (defined ($line = <$handle>)) {
      chomp $line;
      if($line){
        print STDOUT "\033[2J";
        print STDOUT "\033[0;0H";
				print STDOUT  $line . "\n";
      }else{
				print STDOUT  "okk\n";
        exit;
      }
		}
		kill("TERM", $kidpid);                  # send SIGTERM to child
}
# the else{} block runs only in the child process
else {
   # copy standard input to the socket
   if(@ARGV){
     my ($ln) = pop @ARGV;
     print $handle $ln  . "\n";
    while (defined ($line = readkey())) {
      #      print "jsdfsfd\n";
        print $handle $line . "\n";
    }
   }else{
    while (defined ($line = <STDIN>)) {
      #      print "jsdfsfd\n";
        print $handle $line . "\n";
    }
   }
}
