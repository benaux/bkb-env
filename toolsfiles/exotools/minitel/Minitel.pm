package Minitel;

use strict;
use warnings;

use File::Find;
use Data::Dumper;
use Minitel::Pager;

sub _q {
   my ($kv, $arg) = @_;
   return ()
}

sub _read {
   my ($kv, $fname) = @_;

   my $err;
   open (my $fh, '<', $fname ) || do {$err = 1};

   if($err){
      return ("no file good", "no file goodi");
   }else{

      push @{$kv->{hist}}, "read $fname";

      my @lns = <$fh>;
      close $fh;

      $kv->{lns} = \@lns;
      $kv->{crs} = 0;


      my $txt = Minitel::Pager::pager(0, $kv, 0, \@lns);

      return ($txt, "show file $fname");
   }
}


sub _search {
  my ($kv, @words) = @_;
  my @files;
  my $dirpath=qw(/Users/bkb/r/infotxt);

  return ("Err: no dirpath $dirpath") unless (-e $dirpath);

  find({ wanted => sub {
        push @files, 
         $File::Find::name if (-f $File::Find::name and /(\.txt|\.html|\.md)$/);
     },  follow => 1 }, $dirpath);

  $kv->{files} = \@files;

  return ("ok files loaded", );
}

sub dispatch {
  my ($kv, $cmd, $args) = @_;


  my %cases = (
    search => \&_search,
    G => \&Minitel::Pager::_G,
    g => \&Minitel::Pager::_g,
    q => \&_q,
    a => \&Minitel::Pager::_a,
    k => \&Minitel::Pager::_k,
    read => \&_read ,
    set => sub {
      $kv->{vars}->{$args->[0]} = $args->[1];
      return    ("value set", undef);
    },
    get => sub {
      my ($v) =$kv->{vars}->{$args->[0]}; 
      return ($v, undef);
    },
  );

  my $case = $cases{$cmd};

  my ($serv_resp, $client_resp) = ($case)
   ?  $case->($kv, @$args)
   : ("could not find cmd $cmd", "could not find cmd $cmd");

   return  ($serv_resp, $client_resp) ;

   #my $i = 1;
        #my $txt = join "\n" , 
        #    reverse (map { $i++ . " $_" } @{$v});
}

1;
