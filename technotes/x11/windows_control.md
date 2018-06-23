### Window Control


List all windows:
   xwininfo -tree -root

or faster with xprop

   xprop -root | grep ^_NET_CLIENT_LIST

Knowing a window handle obtained like this:

   xwininfo -root -tree -children|grep -i "some window title"


Find window

   wmctrl -a "any substring from a window title"


