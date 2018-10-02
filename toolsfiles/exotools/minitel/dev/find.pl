use File::Find;

use List::MoreUtils qw(all);

sub filter {
  my ($word_data) = shift;

  #(all { $f =~ /$_/i } @words){
  #         push @files, $f;
  #      }
}

sub findfiles {
  my (@words) = @_;

  my @files;
  my @dirpath=qw(/Users/bkb/r/infotxt);
  find({ wanted => sub {
        my $f = $File::Find::name if (-f $File::Find::name and /(\.txt|\.html|\.md)$/);

        if(all { $f =~ /$_/i } @words){
           push @files, $f;
        }
     },  follow => 1 }, @dirpath);

   return \@files
}


sub main {
  my ($files) = findfiles(@ARGV);
  print map { $_ . "\n" }  @$files;
}

main() if not caller();


