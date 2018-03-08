Installin Env
=============


Clone repo: git clone https://auxdir@bitbucket.org/auxdir/devenv.git


Push changes back:
Prepare SSH:

Create a ssh key for this machine 'mallrats' with the twik key bkb.a_special...

   ssh-keygen -t rsa -b 4096 -C "auxdir_mallrats_160520 w/ bkb.A_special25v151001.1"


Add host to ~/.ssh/config

   Host bitbucket.org-auxdir
       HostName bitbucket.org
       IdentityFile /home/bkb/.ssh/auxdir_mallrats_160520

Add location to .git/config:

   [remote "bitbucket"] 
      url = git@bitbucket.org-auxdir:auxdir/env_pub.git
      fetch = +refs/heads/*:refs/remotes/origin/*
   [branch "master"]
      remote = bitbucket
      merge = refs/heads/master
   [user]
      email = bkb@auxdir.com
      name = bkb
