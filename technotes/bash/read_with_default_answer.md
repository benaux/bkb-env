Bash: read with default answer


   read -p "Enter: " name
   name=${name:-Richard}
   echo $name


credit: http://stackoverflow.com/questions/2642585/read-a-variable-in-bash-with-a-default-value
