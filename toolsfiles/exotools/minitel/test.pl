use strict;
use warnings;

use lib '.';

use Data::Dumper;

use Minitel;
use Minitel::Pager;

my %kv1 = ();

my ($txt1) = Minitel::_read(\%kv1, 'test.md');

die 'xxxx ' . Dumper $txt1;

my @lines = ();
my %kv = (crs => 4, lns => \@lines );

@lines = (
  "jsdf akak xxkk \n", "ooo ii lasjdf ajskeer\n", "kkkkoo llnn eeell\n", "qiiiq iuier jsdf inn\n",
  "jsdf akak xxkk \n", "ooo ii lasjdf ajskeer\n", "kkkkoo llnn eeell\n", "qiiiq iuier jsdf inn\n",
  "jsdf akak xxkk \n", "ooo ii lasjdf ajskeer\n", "kkkkoo llnn eeell\n", "qiiiq iuier jsdf inn\n",
  "jsdf akak xxkk \n", "ooo ii lasjdf ajskeer\n", "kkkkoo llnn eeell\n", "qiiiq iuier jsdf inn\n",
  "jsdf akak xxkk \n", "ooo ii lasjdf ajskeer\n", "kkkkoo llnn eeell\n", "qiiiq iuier jsdf inn\n",
  "jsdf akak xxkk \n", "ooo ii lasjdf ajskeer\n", "kkkkoo llnn eeell\n", "qiiiq iuier jsdf inn\n",
  "jsdf akak xxkk \n", "ooo ii lasjdf ajskeer\n", "kkkkoo llnn eeell\n", "qiiiq iuier jsdf inn\n",
  "jsdf akak xxkk \n", "ooo ii lasjdf ajskeer\n", "kkkkoo llnn eeell\n", "qiiiq iuier jsdf inn\n",
  "jsdf akak xxkk \n", "ooo ii lasjdf ajskeer\n", "kkkkoo llnn eeell\n", "qiiiq iuier jsdf inn\n",
  "jsdf akak xxkk \n", "ooo ii lasjdf ajskeer\n", "kkkkoo llnn eeell\n", "qiiiq iuier jsdf inn\n",
  "jsdf akak xxkk \n", "ooo ii lasjdf ajskeer\n", "kkkkoo llnn eeell\n", "qiiiq iuier jsdf inn\n",
  "jsdf akak xxkk \n", "ooo ii lasjdf ajskeer\n", "kkkkoo llnn eeell\n", "qiiiq iuier jsdf inn\n",
  "jsdf akak xxkk \n", "ooo ii lasjdf ajskeer\n", "kkkkoo llnn eeell\n", "qiiiq iuier jsdf inn\n",
  "jsdf akak xxkk \n", "ooo ii lasjdf ajskeer\n", "kkkkoo llnn eeell\n", "qiiiq iuier jsdf inn\n",
  "jsdf akak xxkk \n", "ooo ii lasjdf ajskeer\n", "kkkkoo llnn eeell\n", "qiiiq iuier jsdf inn\n",
  "jsdf akak xxkk \n", "ooo ii lasjdf ajskeer\n", "kkkkoo llnn eeell\n", "qiiiq iuier jsdf inn\n",
  "jsdf akak xxkk \n", "ooo ii lasjdf ajskeer\n", "kkkkoo llnn eeell\n", "qiiiq iuier jsdf inn\n",
  "jsdf akak xxkk \n", "ooo ii lasjdf ajskeer\n", "kkkkoo llnn eeell\n", "qiiiq iuier jsdf inn\n",
  "jsdf akak xxkk \n", "ooo ii lasjdf ajskeer\n", "kkkkoo llnn eeell\n", "qiiiq iuier jsdf inn\n",
  "jsdf akak xxkk \n", "ooo ii lasjdf ajskeer\n", "kkkkoo llnn eeell\n", "qiiiq iuier jsdf inn\n",
);




print Minitel::_a(\%kv);
