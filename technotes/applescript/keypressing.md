Keypressing with applescript
-------------------------------


   #!/bin/bash
   osascript <<EOD
     tell application "Google Chrome"
         activate
     end tell
     tell application "System Events"
         key down {command}
         key down {shift}
         keystroke "f"
         key up {shift}
         key up {command}
     end tell
   EOD
