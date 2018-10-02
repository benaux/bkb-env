use strict;
use warnings;
use Data::Dumper;
use Cwd 'abs_path';
use File::Basename;



my @one = 'a'..'z';
my @two = 'a'..'z';
my @three = 'a'..'z';

my $one_i = 0;
my $two_i = 0;
my $three_i = 0;


my @links;
sub counter {
  my ($href, $arest, $aval, $dirname, $fileurl) = @_;

   my $id;
  if ($one_i > 25 ) {
    $two_i++;
    $one_i = 0;
  }

  $id = $two[$two_i] . $one[$one_i];
  $one_i++;
  # because of vim in elinks -> gg
  if ($id eq 'gg'){ return counter($href); }

  my $url;
  if ($href =~ /^(\w+)\:\/\/\+/){
    $url = $href;
  }elsif ($href =~ /^\#([\w\-\_]+)/){
    $url = $fileurl . '#' . $1;
  }else{
      my $basename  = basename($href);
      $url = "$dirname/" . $basename ;
    }

  push @links, "$id $url\n";
  my ($ret) ="<a href='$url' $arest >[$id] $aval</a>" ; 
  return $ret;
};

my $counterc = \&counter;


sub proc_html {
  my ($document, $fileurl, $fname) = @_;

  ($fname) = $fileurl =~ s/^file\:\/\/// unless($fname);

  my $dirname  = dirname($fileurl);
  my @out;
  foreach my $ln (split "\n", $document){
    #$ln =~ s/\<a\s+href\s*=\s*[\"\']?([^"\s\>]+)[\"\']?\s*(.*)\s*\>/$counterc->($1, $2, $dirname, $fileurl)/ge;
    $ln =~ s/\<a[^>]*href=[\"\']([^"]*)[\"\']([^>]*)>([^<]*)\<\/a\>/$counterc->($1, $2, $3, $dirname, $fileurl)/ge;
    push @out, $ln . "\n";
  }

  my $outname = "$ENV{HOME}/.elinks-out";
  open (my $ofh , '>', $outname) || die "Err: no outfile $outname\n";
  print $ofh @links;
  close $ofh;

  my $ret = join '',  @out;
  return $ret;

}

sub main {
   my ($filename) = @_;

   open(my $f, '<', $filename) or die "Err $filename: $!\n";
   my $string = do { local($/); <$f> };
   close($f);

   chomp($filename);
   my ($fileurl) = 'file://' . $filename;

   print (proc_html($string, $fileurl, $filename));
}

main(@ARGV) if not caller();

1;

