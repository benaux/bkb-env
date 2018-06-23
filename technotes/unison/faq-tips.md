# Unison FAQ - Tips and Tricks


### I want to ignore deleted files. Is it a good idea to delete archive files after every synchronization, so that Unison consider all of my files as new and copies them on the replica where they are not ?

### I want to use Unison to synchronize really big replicas. How can I improve performance?

When you synchronize a large directory structure for the first time,
Unison will need to spend a lot of time walking over all the files and
building an internal data structure called an archive. There is no way
around this: Unison uses these archives in a critical way to do its
work. While you're getting things set up, you'll probably save time if
you start off focusing Unison's attention on just a subset of your
files, by including the option -path some/small/subdirectory on the
command line. When this is working to your satisfaction, take away the
-path option and go get lunch while Unison works. This rebuilding
operation will sometimes need to be repeated when you upgrade Unison
(major upgrades often involve changes to the format of the archive
files; minor upgrades generally do not.)

Next, you make sure that you are not "remote mounting" either of your
replicas over a network connection. Unison needs to run close to the
files that it is managing, otherwise performance will be very poor. Set
up a client-server configuration as described in the installation
section of the manual.

If your replicas are large and at least one of them is on a Windows
system, you will probably find that Unison's default method for
detecting changes (which involves scanning the full contents of every
file on every sync---the only completely safe way to do it under
Windows) is too slow. In this case, you may be interested in the
fastcheck preference, documented in the section "Fast Update Checking"
of the user manual .

In normal operation, the longest part of a Unison run is usually the
time that it takes to scan the replicas for updates. This requires
examining the filesystem entry for every file (i.e., doing an fstat on
each inode) in the replica. This means that the total number of inodes
in the replica, rather than the total size of the data, is the main
factor limiting Unison's performance.

Update detection times can be improved (sometimes dramatically) by
telling Unison to ignore certain files or directories. See the
description of the ignore and ignorenot preferences in the section
"Preferences" of the user manual .

(One could also imagine improving Unison's update detection by giving it
access to the filesystem logs kept by some modern "journaling
filesystems" such as ext3 or ReiserFS, but this has not been
implemented. We have some ideas for how to make it work, but it will
require a bit of systems hacking that no one has volunteered for yet.)

Another way of making Unison detect updates faster is by "aiming" it at
just a portion of the replicas by giving it one or more path
preferences. For example, if you want to synchronize several large
subdirectories of your home directory between two hosts, you can set
things up like this:

Create a common profile (called, e.g., common) containing most of your
preferences, including the two roots:


   root = /home/bcpierce
   root = ssh://saul.cis.upenn.edu//home/bcpierce
   ignore = Name \*.o
   ignore = Name \*.tmp


Create a default profile default.prf with path preferences for all of
the top-level subdirectories that you want to keep in sync, plus an
instruction to read the common profile:

   path = current

   path = archive

   path = src

   path = Mail

   include common


Running unison default will synchronize everything.

(If you want to synchronize everything in your home directory, you can
omit the path preferences from default.prf.)

Create several more preference files similar to default.prf but
containing smaller sets of path preferences. For example, mail.prf might
contain:


   path = Mail

   include common


Now running unison mail will scan and synchronize just your Mail
subdirectory.

Once update detection is finished, Unison needs to transfer the changed
files. This is done using a variant of the rsync protocol, so if you
have made only small changes in a large file, the amount of data
transferred across the network will be relatively small.

Unison carries out many file transfers at the same time, so the per-file
set up time is not a significant performance factor.


### How do I use USB memory stick/flashdrives with Unison?

Most memory sticks/flashdrives/pendrives/USB sticks come formatted as
FAT. FAT does not support all of the permissions that \*nix systems do,
so Unison must be told not to check file permissions when syncing to
memory sticks.

Secondly, I want to synchronise files in different directories to the
memory stick.

To do that, I create a 'laptop-sync' folder on my laptop. For any file
on my laptop that I want to sync, I create a shortcut to it in the
laptop-sync folder. That folder is often contains nothing but shortcuts.
One other step is to modify the profile to allow links.

If you havn't already, create a new Unison profile and point the first
(local) directory to the 'laptop-sync' folder. Point the second
directory to a folder on the memory stick. To modify the profile, look
in the .unison directory and find the .prf (profile) file with the name
for the memory stick sync. Edit that and add the following lines at the
end:

``` {.escaped}
#  the follow line tells unison to use links
follow = Regex .*

# permissions line is necessary for FAT filesystem on the memory stick to work
# otherwise you keep getting an error message
perms = 0
```


### Is there a way to get Unison not to prompt me for a password every time I run it (e.g., so that I can run it every half hour from a shell script)?

It's actually ssh that's asking for the password. If you're running the
Unison client on a Unix system, you should check out the 'ssh-agent'
facility in ssh. If you do

<div class="vspace">

</div>

<div class="indent">

ssh-agent bash

</div>

(or ssh-agent startx, when you first log in) it will start you a shell
(or an X Windows session) in which all processes and sub-processes are
part of the same ssh-authorization group. If, inside any shell belonging
to this authorization group, you run the ssh-add program, it will prompt
you once for a password and then remember it for the duration of the
bash session. You can then use Unison over ssh---or even run it
repeatedly from a shell script---without giving your password again.

It may also be possible to configure ssh so that it does not require any
password: just enter an empty password when you create a pair of keys.
If you think it is safe enough to keep your private key unencrypted on
your client machine, this solution should work even under Windows.

ssh-keygen is used to create a pair of keys to automate the ssh
authentication. Here is an example:

<div class="vspace">

</div>

<div class="indent">

ssh-keygen (accept all default values)

</div>

<div class="indent">

scp .ssh/id\_rsa.pub my.remotehost.com:.ssh/authorized\_keys

</div>

<div class="vspace">

</div>

### Can Unison be used with SSH's port forwarding features?

Mark Thomas says the following procedure works for him:

After having problems with unison spawning a command line ssh in Windows
I noticed that unison also supports a socket mode of communication
(great software!) so I tried the port forwarding feature of ssh using a
graphical SSH terminal
[TTSSH](http://www.zip.com.au/~roca/ttssh.html){.urllink}

To use unison I start TTSHH with port forwarding enabled and login to
the Linux box where the unison server (unison -socket xxxx) is started
automatically. In windows I just run unison and connect to localhost
(unison socket://localhost:xxxx/ ...)

Richard Murri also commented that the following works for him:\
Using ssh port forwarding can be easily done without using the unison
server:

<div class="vspace">

</div>

``` {.escaped}
ssh machineA -L 9999:machineB:22
unison a.tmp ssh://user@localhost:9999/a.tmp
```

<div class="vspace">

</div>

### How can I use Unison from a laptop whose hostname changes depending on where it is plugged into the network?

This is partially addressed by the rootalias preference. See the
discussion in the section "Archive Files" of the user manual .

<div class="vspace">

</div>

### Can I use Unison with version control systems (e.g., CVS, Subversion, darcs)?

-   darcs: <http://darcs.net/RelatedSoftware/Unison>

<div class="vspace">

</div>

### How can I allow a Unison profile to be initiated from either end?

Imagine syncing between a laptop and a desktop computer, using the
"minimal profile" from the manual. But you want to be able to initiate
the synchronization from both computers. On the desktop use the profile:

<div class="vspace">

</div>

``` {.escaped}
root = /home/bcpierce
root = ssh://laptop//home/bcpierce

include homedir
```

While on the laptop you use:

<div class="vspace">

</div>

``` {.escaped}
root = /home/bcpierce
root = ssh://desktop//home/bcpierce

include homedir
```

On both ends, you maintain the included file `.unison/homedir.prf`, with
the paths (and other settings):

<div class="vspace">

</div>

``` {.escaped}
path = current
path = common
path = .netscape/bookmarks.html
path = .unison/homedir.prf
```

Note that the `homedir.prf` file itself is specified as a path to be
synchronized.

<div class="vspace">

</div>

### I need to use Unison with Linux and Windows, with unicode characters in file name. How to deal with this situation ?

First of all, remember Unison can manage Unicode characters on Linux
platform, but not on Windows one (I don't know about this problem on
other platforms). So if you need to synchronise between Windows and
Linux, let's run Unison on Linux only ! For this, you have to mount the
Windows shares on Linux in such a way that Unicode characters will be
well managed. Here is a sample of line you have to put in /etc/fstab
(you need root access to edit this file):

<div class="vspace">

</div>

``` {.escaped}
//IP_ADDRESS/WINDOWS_SHARE_NAME    /LOCAL_PATH_TO_MOUNT_TO    cifs \
rw,uid=UID,gid=GID,umask=000,file_mode=0777,dir_mode=0777,iocharset=utf8,credentials=/root/.smbcred  0  0
```

Of course, you have to replace:

-   IP\_ADDRESS with the real address of the computer under Windows
    which hold the share (it's better if you forget DHCP in this case,
    or you will have to manage the host names)
-   WINDOWS\_SHARE\_NAME with the real share name ...
-   LOCAL\_PATH\_TO\_MOUNT\_TO with the path on the Linux computer where
    you want the share to be mounted in
-   UID and GID with the real values for the user which you want to own
    the mounted share

Values for umask, file\_mode and dir\_mode should be choosen accordingly
to your needs. These samples values are very permissive one, to be used
in a trusted environnement.

The file "/root/.smbcred" file contents is:

<div class="vspace">

</div>

``` {.escaped}
username=WINDOWS_USER_NAME
password=WINDOWS_USER_PASSWORD
```

Don't forget to add a blank line at the end of this file, it seems to be
important for cifs. Of course, this file should be owned be root, to be
safe.

Now you should be able to synchronize your Linux and Windows hosts, with
Unicode in file name ! Of course, there is a (quite big) problem with
speed when used on big amount of data, but this is out of the scope of
this post !

<div class="vspace">

</div>

### How do I use ssh with a non-standard port ?

In your .prf file use this structure for your root entry:

<div class="vspace">

</div>

``` {.escaped}
ssh://user@host:port//path/to/directory
```

Put your own user, host, port, and path. The double slash after the port
is important.

<div class="vspace">

</div>

### How to synchronize with a computer behind a firewall?

In our office most computers are kept behind a firewall with external
access via ssh only allowed to the server computer. Interactively, one
would log onto the server computer first, and then ssh into the desired
machine. I finally figured out how I can do this via a pipe such that I
can use unison to synchronize with computers behind the firewall. Set up
a script sshpipe.sh, e.g. in /home/user/bin:

<div class="vspace">

</div>

``` {.escaped}
#!/bin/bash
# very simple ssh pipe
# Use like this:
# unison-gtk -sshcmd /home/user/bin/sshpipe.sh
intermediate=gateway.cam.ac.uk
ssh $intermediate -C -e none ssh $@
```

gateway.cam.ac.uk is the name of the machine which is accessible from
outside the firewall. Now just run unison with the sshcmd option

<div class="vspace">

</div>

``` {.escaped}
unison -sshcmd /home/user/bin/sshpipe.sh ...
```

where the root parameters for unison are set up in the usual way, just
as if the initiating computer was also behind the firewall.

In this case I have hardwired my preferred ssharg option (-C) but it
would be relatively straightforward to parse the arguments for options
and pass these on to ssh. Of course sshcmd can also be set in the
profile rather than as an argument.

This description assumes you have set up a ssh keychain mechanism such
that ssh from the intermediary to the computer to be synchronized works
without a further password check (i.e. the only password required will
be the on to ssh from the initiating computer to the intermediary). See
<http://www.ibm.com/developerworks/library/l-keyc.html> or
<http://www.gentoo.org/proj/en/keychain/> on guidance for setting up ssh
keychains. It is possible that the above method even works where the
password needs to be entered twice (the first for access to the
intermediary, the second to the one to be synchronized with) but I have
no easy way of testing this.

<div class="vspace">

</div>

### Is it possible to synchronize two hosts via a removable drive?

Yes, there are 2 ways in which this can be done.

1\) You can use the removable drive as the hub of your unison
sychronization, and sync each computer with the removable drive.

2\) There is a hybrid, network/removable drive hack that can be used by
creating a shell script. I use this method to keep a file server at my
home office and regular office in sync.

Pros:

-   You do not need enough free space on the removable drive for the
    entire replica.
-   You don't have to worry about a large file hogging your bandwidth

Cons:

-   It may take several iterations of being executed on the client and
    server before the replicas are in sync. This is because the file is
    not actually transferred at the time unison is run so you will get
    this error:

`External copy program did not create target file (or bad length)`{.escaped}

So only 1 file per directory will be copied to the removable drive.

Here are the steps required:

1.  Add the following lines to your normal synchronization profile or
    modify the existing settings. This will tell rsync to ignore any
    files that are &gt; than specified size (xxx).

``` {.escaped}
copyprog      =   rsync --inplace --compress ""--max-size=xxx""
copyprogrest  =   rsync --partial --inplace --compress ""--max-size=xxx""
```

1.  Make a copy of the profile that you will use for sneakernet
    synchronization with the following line

``` {.escaped}
copyprog      =   sneakernet.sh LocalRoot RemoteRoot SneakerNetPath
```

1.  Create this shell script in your path. I called mine sneakernet.sh
    as indicated in step 2.

``` {.escaped}
#!/bin/sh

# Usage
# $1 = the local root
# $2 = the remote path that unison will pass to rsync
# $3 = the path used for the sneakernet, 
#      ie the path to the folder on a usb drive moved between locations
# $4 = Souce of the copy as sent by unison
# $5 = Destination of the copy as sent by unison


# Debuggin stuff
OUTFILE=/dev/null

SOURCEFILE=$4
DESTFILE=`echo $4 | sed "s|$1|$3|"`
DESTDIR=`echo $DESTFILE | sed 's:\(/.*/\).*:\1:'`

echo $SOURCEFILE
echo $DESTFILE
echo $DESTDIR

if [ -s $SOURCEFILE ]
then
        #echo Copying from local
        mkdir -p $DESTDIR >> $OUTFILE
        cp -af $SOURCEFILE $DESTFILE >> $OUTFILE
else
        SOURCEFILE2=`echo $4 | sed "s|$2|$3|"`
        DESTFILE2=$5
        DESTDIR2=`echo $DESTFILE2 | sed 's:\(/.*/\).*:\1:'`

        #echo $SOURCEFILE2
        #echo $DESTFILE2

        if [ -s $SOURCEFILE2 ]
        then
                mkdir -p $DESTDIR2 >> $OUTFILE
                cp -af $SOURCEFILE2 $DESTFILE2 >> $OUTFILE
        fi
fi
```

<div class="vspace">

</div>

</div>

<div id="wikifoot">

<div class="footnav">

[Edit](https://alliance.seas.upenn.edu/~bcpierce/wiki/index.php?n=Main.UnisonFAQTips?action=edit)
-
[History](https://alliance.seas.upenn.edu/~bcpierce/wiki/index.php?n=Main.UnisonFAQTips?action=diff)
-
[Print](https://alliance.seas.upenn.edu/~bcpierce/wiki/index.php?n=Main.UnisonFAQTips?action=print)
- [Recent
Changes](https://alliance.seas.upenn.edu/~bcpierce/wiki/index.php?n=Main.RecentChanges)
-
[Search](https://alliance.seas.upenn.edu/~bcpierce/wiki/index.php?n=Site.Search)

</div>

<div class="lastmod">

Page last modified on November 25, 2014, at 05:10 PM

