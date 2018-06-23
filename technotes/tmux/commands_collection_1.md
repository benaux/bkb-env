Tmux: Commands collection
=========================



Check if Session exists in Bash:

   if tmux has-session -t "mysession" 2>/dev/null ; then 
      echo "session is here"
   fi


Check if a specific Window exists in Bash (and then attach to this window)"

      if  tmux list-windows -t "mysession" | grep "windowname"  ; then
         tmux attach -t "mysession" \; select-window -t "windowname" 
      fi


Create a new Window in a existing Session, give it a Name and run a Script:

   tmux new-window -t "mysession" -n "mywindow" bash myscript.sh

Create a new Session, give the first Window a Name and run a Script:

   tmux new -s mysession -n myname bash myname 


