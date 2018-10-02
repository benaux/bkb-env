


die () { echo $@; exit 1; }

[ -n "$BKB_DEFAULT_BROWSER" ] || die "Err: no default browser in variable BKB_DEFAULT_BROWSER"

os=$(uname)

os_not_impl () { die "Err: os $os not implemented yet"; }

case "$BKB_DEFAULT_BROWSER" in 
  Iridium)
    case "$os" in
      Darwin)
         osascript -e 'tell application "Iridium" to return URL of active tab of front window'
         ;;
       *)
         os_not_impl
         ;;
     esac
     ;;
   *)
     die "Err: Browser $BKB_DEFAULT_BROWSER not implemented yet"
     ;;
 esac

