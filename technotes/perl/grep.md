Perl grep


 @profiles = grep @{ $blocks{$_} } > 0, (keys %blocks);
