Perl-oneliner: search and replace in files


backup of each as *.bak:

perl -p -i.bak -e "s/\|/x/g" *  



with xargs and pie, no .bak files here

find . | xargs perl -p -i -e 's/something/else/g'
