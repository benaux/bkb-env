cwd=$(pwd)

warn () { 
  #echo "Warn: " $@ ; 
  :
}

homebase=$HOME/homebase
[ -d "$homebase" ] || { echo "Err: no homebase" ; exit 1; }

redir=$homebase/redir
mkdir -p $redir/user
mkdir -p $redir/dirs

hname=$(hostname)

decimal=$HOME/decimal

rm -f $redir/decimal
ln -s $decimal $redir/decimal

Documents=$HOME/Documents
mkdir -p $Documents
rm -f $Documents/bkb
ln -s $decimal/bkb $Documents/bkb
rm -f $redir/Documents
ln -s $Documents $redir/Documents

rm -rf $redir/dirs
mkdir -p $redir/dirs
for d in $homebase/*; do
  [ -d "$d" ] || continue
  for dd in $d/*; do
   [ -d "$dd" ] || continue
   bd=$(basename $dd)
   case "$bd" in
     *.*-*.*)
       if [ -d "$redir/dirs/$bd" ] ; then
         echo "Err: $bd already exists in $redir/dirs"; 
         exit 1; 
       else
         ln -s $dd $redir/dirs/
       fi
       ;;
     *)
       :
       ;;
   esac
 done
done

handle_decimal_after () {
  local user="$1"
  local bddd="$2"
  local ddd="$3"

  rm -f $decimal/$user/$bddd
  ln -s $ddd $decimal/$user/$bddd

  mkdir -p $decimal/$user/before

  rm -f $decimal/$user/before/$bddd
  ln -s $ddd $decimal/$user/before/$bddd

  mkdir -p $decimal/$user/after

  for dddd in "$ddd"/* ; do
    [ -d "$dddd" ] || continue
    bdddd=$(basename $dddd)

    case "$bdddd" in 
      *_*.*)
        rm -f "$decimal/$user/$bdddd"
        ln -s "$dddd" "$decimal/$user/$bdddd"

        rm -f "$decimal/$user/after/$bdddd"
        ln -s "$dddd" "$decimal/$user/after/$bdddd"
        ;;
      *)
        warn "doing nothing with $dddd"
        :
        ;;
    esac
 done
}

handle_decimal_sub () {
  local user="$1"
  local bddd="$2" 
  local ddd="$3" 

  mkdir -p $decimal/$user/before

  rm -f $decimal/$user/$bddd
  ln -s $ddd $decimal/$user/$bddd

  rm -f $decimal/$user/before/$bddd
  ln -s $ddd $decimal/$user/before/$bddd

  for dddd in "$ddd"/* ; do
    [ -d "$dddd" ] || continue
    bdddd=$(basename $dddd)

    case "$bdddd" in 
      *_*)
        rm -f $decimal/$user/$bdddd
        ln -s $dddd $decimal/$user/$bdddd

        rm -f $decimal/$user/before/$bdddd
        ln -s $dddd $decimal/$user/before/$bdddd
        for ddddd in "$dddd"/* ; do
            [ -d "$ddddd" ] || continue
            bddddd=$(basename $ddddd)
            case "$bddddd" in 
              *_*.*)
                rm -f $decimal/$user/$bddddd
                ln -s $ddddd $decimal/$user/$bddddd

                rm -f $decimal/$user/after/$bddddd
                ln -s $ddddd $decimal/$user/after/$bddddd
               ;;
               *)
               warn "doing nothing with '$bddddd' from '$ddddd'"
               ;;
            esac
          done
        ;;
      *)
        warn "doing nothing with '$bdddd' from '$dddd'"
        ;;
    esac
 done
}

for d in $homebase/*; do
  [ -d "$d" ] || continue

  bd=$(basename $d)

  #echo bd $bd

  case "$bd" in
      *dir_*_$hname) 
         rm -f $redir/dirs/$bd
         ln -s $d $redir/dirs/$bd
      ;;
    *) continue ;;
  esac

  rm -f $redir/$bd
  ln -s $d $redir/$bd

  for dd in "$d"/*; do
    [ -d "$dd" ] || continue
    bdd=$(basename $dd)

    #echo bdd $bdd

    case "$bdd" in
      *.*-*.*)
        diruser=${bdd%%.*}
        diritem=${bdd#*.}

        #echo xbdd $bdd

        mkdir -p $redir/user/$diruser
        rm -f  $redir/user/$diruser/$diritem
        ln -s  $dd $redir/user/$diruser/$diritem

        case "$bdd" in
           *.*_*-*)
            item=$(echo "$bdd" | perl -ne '/\w+\.(\w+)\_\w+\-\w+/ && print $1')
            mkdir -p $redir/$item
            rm -f $redir/$item/$bdd
            ln -s $dd $redir/$item/$bdd
            ;;
          *) : ;;
        esac

        mkdir -p $decimal/$diruser/before
        mkdir -p $decimal/$diruser/after

        # rm -f $redir/${diruser}-decimal
        # ln -s $decimal/${diruser} $redir/${diruser}-decimal

        rm -f $redir/${diruser}
        ln -s $decimal/${diruser} $redir/${diruser}

        for ddd in $dd/* ; do
          [ -d "$ddd" ] || continue
          bddd=$(basename "$ddd")

          # echo bddd $bddd

          case "$bddd" in 
            _*) : ;;
            *_*_*)
              itemdir=${bddd%%_*}
              itemtarget=${bddd#*_}

              mkdir -p $redir/$itemdir
              rm -f $redir/$itemdir/$itemtarget
               ln -s $ddd $redir/$itemdir/$itemtarget

              # echo xitem $itemdir

              decimal_before=$(echo "$bddd" | perl -ne '/^\w+\_[\w\-]+\_(\d+)$/ && print $1')
              if [ -n "$decimal_before" ] ; then
                # echo before $ddd
                handle_decimal_after "$diruser" "$bddd" "$ddd"
              else
               decimal_sub=$(echo "$bddd" | perl -ne '/^\w+\_\w+\_(\d+\w+)$/ && print $1')
               if [ -n "$decimal_sub" ] ; then
                 # echo dd $decimal_sub
                  handle_decimal_sub "$diruser" "$bddd" "$ddd"
                else
                  warn "unhandled dir: $ddd"
                fi
              fi
              ;;
            *) : ;;
          esac
        done
        ;;
      *)
        continue
        ;;
    esac
  done
done
