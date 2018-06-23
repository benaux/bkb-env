# SSH keys not loaded between tmux sessions on mac os (sierr)

Problem: the password has to be given in each session


ssh-add -l prints The agent has no identities.


Solution:

new terminal:

$ tmux new -s temp
$ ssh-agent
$ ssh-add


src: https://apple.stackexchange.com/questions/257107/ssh-under-tmux-always-asks-for-password 
