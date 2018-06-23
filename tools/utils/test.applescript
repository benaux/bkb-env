tell application "Iridium"
  activate
  set newURL to "http://forum.keyboardmaestro.com"
if (count of windows) is 0 or front window is not visible then
    make new window
  else
    make new tab at end of tabs of front window
  end if
  
  set URL of active tab of window 1 to newURL
end tell
