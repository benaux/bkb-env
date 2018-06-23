# How keychain and fish shell play together 



this is the only way it worked


    set -gx HOSTNAME (hostname)
    if status --is-interactive;
      eval (keychain --eval   --quiet -Q ~/.ssh/auxsend_rsa 8BB04488 )

      [ -e $HOME/.keychain/$HOSTNAME-fish ]; and . $HOME/.keychain/$HOSTNAME-fish
      [ -e $HOME/.keychain/$HOSTNAME-fish-gpg ]; and . $HOME/.keychain/$HOSTNAME-fish-gpg
    end


8BB04488 is the ID of the master gpg key


