

os=$(uname)
cwd=$(pwd)

rm -f $HOME/.tmux.conf

rm -f $HOME/.tmux-common.conf
ln -s $cwd/tmux-common.conf ~/.tmux-common.conf

die () { echo $@; exit 1; }


os_conf="tmux-${os}.conf" 

if [ -f "$os_conf" ] ; then
   ln -s $cwd/$os_conf $HOME/.tmux.conf
else
   die "todo ' $os"
fi
