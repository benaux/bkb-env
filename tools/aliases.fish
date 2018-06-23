function die
   echo $argv
   exit 1
end

function cd_syncdir_bkb
   set syncdir_bkb $HOME/homebase/syncdir_bkb_skyfall
   set homebase $HOME/homebase
   pushd $homebase/*/*$argv[1]*
end

function cd_syncdir_bkb_sub
   set syncdir_bkb $HOME/homebase/syncdir_bkb_skyfall
   set homebase $HOME/homebase
   set length (string length $argv[1])
   set path ''
   switch $length
      case 3
         set path $homebase/*/*bkb*/*_$argv[1]*
      case 5
         set path $homebase/*/*bkb*/*/*_$argv[1]*
      case 2
         set path $homebase/*/*bkb*/*_$argv[1]
      case '*'
         set path $homebase/*/*bkb*/*_$argv[1]
   end

   if test -z "$path"
     set path $homebase/*/*bkb*/*/*_$argv[1]
     [ -z "$path" ]; and die "Err1: could not find path in $argv[1]"
     [ -d "$path" ]; or die "Err:2 could not find path in $argv[1]"
      pushd "$path"
   else if test -d "$path"
     pushd $path
   else
     echo "Err: invalid path in $argv[1]"
     echo "   Here is result"
     echo $path
   end
end
 
set redir $HOME/homebase/redir

alias 1x 'find -L ~/homebase  -maxdepth 3  -path $redir -prune -o -type d | perl -ne "/_1[\d(-\d\d)]/ && print"'
alias 2x 'find -L ~/homebase  -maxdepth 3  -path $redir -prune -o -type d | perl -ne "/_2[\d(-\d\d)]/ && print"'
alias 3x 'find -L ~/homebase  -maxdepth 3  -path $redir -prune -o -type d | perl -ne "/_3[\d(-\d\d)]/ && print"'
alias 4x 'find -L ~/homebase  -maxdepth 3  -path $redir -prune -o -type d | perl -ne "/_4[\d(-\d\d)]/ && print"'
alias 5x 'find -L ~/homebase  -maxdepth 3  -path $redir -prune -o -type d | perl -ne "/_5[\d(-\d\d)]/ && print"'
alias 6x 'find -L ~/homebase  -maxdepth 3  -path $redir -prune -o -type d | perl -ne "/_6[\d(-\d\d)]/ && print"'
alias 7x 'find -L ~/homebase  -maxdepth 3  -path $redir -prune -o -type d | perl -ne "/_7[\d(-\d\d)]/ && print"'
alias 8x 'find -L ~/homebase  -maxdepth 3  -path $redir -prune -o -type d | perl -ne "/_8[\d(-\d\d)]/ && print"'
alias 9x 'find -L ~/homebase  -maxdepth 3  -path $redir -prune -o -type d | perl -ne "/_9[\d(-\d\d)]/ && print"'

alias bb 'cd_syncdir_bkb_sub'

alias b1 'cd_syncdir_bkb b1'
alias b2 'cd_syncdir_bkb b2'
alias b3 'cd_syncdir_bkb b3'
alias b4 'cd_syncdir_bkb b4'
alias b5 'cd_syncdir_bkb b5'
alias b6 'cd_syncdir_bkb b6'
alias b7 'cd_syncdir_bkb b7'
alias b8 'cd_syncdir_bkb b8'
alias b9 'cd_syncdir_bkb b9'
alias b10 'cd_syncdir_bkb b10'
alias b11 'cd_syncdir_bkb b11'
alias b12 'cd_syncdir_bkb b12'

alias nsb 'source ~/aux/utils/node-switch bkb'
alias nlb 'source ~/aux/utils/node-list bkb'

alias nsa 'source ~/aux/utils/node-switch aux-bkb'
alias nla 'source ~/aux/utils/node-list aux-bkb'

alias na 'source ~/aux/utils/node-switch aux-bkb'

alias twikpw-ben 'twikpw ben_2P0a.pwc-ii'

alias chrome "/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome"
alias rm  "rm -f"
alias passtab-bkb_1U0a 'passtab-profile bkb_1U0a'
alias hap hashapass
alias pw-seven-bkb 'pw "bkb_H3-0c-ii" "seven;bkb;###"'
alias pw-seven-root 'pw "admin_H3-0c-ii" "seven;root+ssh;###"'
alias pw-ronin-admin 'pw "admin_H3-0c-ii" "ronin;admin"'
alias pw-fritz-admin 'pw "admin_H3-0c-ii" "fritz;admin"'
alias pw-topgun-admin 'pw "admin_H3-0c-ii" "topgun;admin"'
alias pw-topgun-jakobshare 'pw "jakob_H3-0c" "topgun;jakobshare;##"'

alias . "ls ."
alias fm "urxvtc -e /usr/local/bin/vifm"

alias love "/Applications/love.app/Contents/MacOS/love"

alias xreload "xrdb ~/.Xresources"
alias cdd "cd ~/dev/"
alias cdi "cd ~/dev/i"
alias cdr "cd ~/dev/repos"

alias today 'date "+%F"'
alias now 'date "+%F %T"'

alias sf "showfile"

alias u untar

alias ssh-restart "sudo service ssh restart"
alias sshr ssh-restart

alias apts "apt-cache search"
alias apti "sudo apt-get install"
alias aptu "sudo apt-get update"

alias chmox "chmod 0755"

#alias copy "xclip -sel clip"
#alias paste "xclip -sel clip -o"


#alias ack "ack-grep"

alias upl "/home/bkb/local/perl/upl/upl -I /home/bkb/local/perl/upl/lib"

alias l "ls -Fhtlr"
alias sl "ls"


alias worg "mvim --remote-silent"

alias lizpop "python -O -m lizpop.run"
alias lp "python -O -m lizpop.run"

# tmux
alias tmuxlist "tmux list-sessions"
alias txl tmuxlist
alias tmuxl tmuxlist

alias mp "mkdir -p "
alias mkdri "mkdir -p"

alias sshkeyless "ssh -o PreferredAuthentications=password -o PubkeyAuthentication=no"
