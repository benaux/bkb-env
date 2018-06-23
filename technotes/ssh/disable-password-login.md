ssh: disable login password

in /etc/ssh/sshd_config

   ChallengeResponseAuthentication no
   PasswordAuthentication no
   UsePAM no
