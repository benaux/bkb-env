my $key;

open(TTY, "+</dev/tty") or die "no tty: $!";
system "stty  cbreak </dev/tty >/dev/tty 2>&1";
$key = getc(TTY);       # perhaps this works
print 'kkkk '  . $key;
