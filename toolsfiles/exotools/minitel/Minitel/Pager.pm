package Minitel::Pager;

use strict;
use warnings;

use Data::Dumper;

sub pager {
  my ($offset, $kv, $crs, $lns) = @_;


   my $begin_crs =  ($crs + $offset) ;
   my $txt = "";
   if ($begin_crs < 0){
     $txt = "!!!Belll !! \n";
     $begin_crs = 0;
   }
   my $end_crs = $begin_crs + 25;
   my $i = 0;

   for (my $i=0; $i < scalar(@$lns); $i++) {
     if($i >= $begin_crs){
       if ($i < $end_crs){
         $txt = $txt . "$i " .  $lns->[$i];
       }
     }
   }

  $kv->{crs} = $begin_crs;
   return $txt;
}

sub _G {
   my ($kv, $arg) = @_;

   my $lns = $kv->{lns};

   my $lni = scalar @$lns;

   my $crs = ($lni > 25)
      ? ($lni - 25)
      : 0;

   my ($txt) = pager(0, $kv, $crs, $lns );

   return ($txt, "press 'q' for leaving");
}

sub _g {
   my ($kv, $arg) = @_;

   my $crs = 0;
   my $lns = $kv->{lns};

   my ($txt) = pager(0, $kv, $crs, $lns );

   return ($txt, "press 'q' for leaving");
}

sub _a {
   my ($kv, $arg) = @_;

   my ($crs) = (exists $kv->{crs})  ? $kv->{crs} : 0 ;
   my $lns = $kv->{lns};

   my ($txt) = pager(5, $kv, $crs, $lns );

   return ($txt, "press 'q' for leaving");
}
sub _k {
   my ($kv, $arg) = @_;

   my ($crs) = (exists $kv->{crs})  ? $kv->{crs} : 0 ;
   my $lns = $kv->{lns};

   my ($txt) = pager(-5, $kv, $crs, $lns );

   return ($txt, "press 'q' for leaving");
}



1;
