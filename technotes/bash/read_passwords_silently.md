Bash: read passwords silently


Read passwords without echoing the input


in bash:

   read -rs passwd


in dash

set 'stty -echo' and the reset to 'stty echo'

   echo -n "PASSWORD: "
   stty -echo 
   read passwd
   stty echo

   echo $passwd
