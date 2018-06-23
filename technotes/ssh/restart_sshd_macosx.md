# ssh: restart on macos 


## Restart SSHd service

sudo launchctl stop com.openssh.sshd
sudo launchctl start com.openssh.sshd


## Load/Unload Settings

   sudo launchctl unload /System/Library/LaunchDaemons/ssh.plist
   sudo launchctl load -w /System/Library/LaunchDaemons/ssh.plist


