use Text::Markdown 'markdown';


my $md = $ARGV[0];

open (my $fh, '<', $md) || die "Err: cannot open $md";

my @lns = <$fh>;
my $text = join '', @lns;

my $html = markdown($text);

print $html;
