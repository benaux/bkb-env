#!/usr/bin/perl
package Md2zim;

=head1 NAME

md2zim

=head1 SYNOPSIS

md2zim.pl <markdownfile> <outdir>

=head1 DESCRIPTION

Turns a markdown file into a zim wiki structure by splitting into sub pages
Also does some Markup translation

=cut

use strict;
use warnings;

use Pod::Usage qw(pod2usage);
use Getopt::Long;
use Data::Dumper;

#no warnings 'once';
use Aux::Lib;

Aux::Lib::import_shell qw(rm);

unless (caller){

	my %opts;

	GetOptions(\%opts, 'help|h|?', 'man' ) || pod2usage(2);

	pod2usage(-exitval => 0, -verbose => 2) if $opts{man};
	pod2usage(2) if $opts{help};
	pod2usage(2) unless @ARGV == 2;

	my ($fname, $outdir) = @ARGV;
	
	die "Err: file $fname not exists" unless (-f $fname);

	rmdir($outdir);
	mkdir($outdir);

	my $ast = run($fname);
	writeout($ast,$outdir); 
}

sub writeout{
	my ($ast,$outdir) = @_; 
	foreach (keys %$ast){
	print $_
	}
}
sub run {
	my ($fname) = @_;

	open(my $fh, '<', $fname) or die "Err: cant open $fname";
	my (%Ast, $Block);

	my $Hd_rx = '^\s*(\#+)\s+(.*)$';
	my $prevlvl = 0;
	my ($title, $prevtitle, $path, $dir) = ();
	my @curpath ;
	while(<$fh>){
		chomp;
		if (/$Hd_rx/){
			my $lvl = split('', $1);
			$title = $2;
			if ($lvl > $prevlvl){
				if($prevtitle){
					$prevtitle =~ s/\s+/\_/g;
					push @curpath , $prevtitle ;
				}
			}elsif ($lvl < $prevlvl){
				pop @curpath foreach(1 .. ($prevlvl - $lvl));
			}else{
			}

			$dir = join '/',  @curpath ;
			$title =~ s/\s+/\_/g; 
			$path = $dir . '/'. $title;
			$Block = [];
			$Ast{$path} = {
				dir => $dir,
				block => $Block,
				};	

			$prevtitle = $title;
			$prevlvl = $lvl;
		}else{
			push @$Block, $_
			}
	}
	return \%Ast;
}


1;

=head1 LICENSE

This is released under the Artistic 
License. See L<perlartistic>.

=head1 AUTHOR

Copyright (C) 2016 Ben Aux 

=cut


