#!/bin/bash
######################################################################################################
##
##  Installer for "Config Editor for Sinden Lightgun"
##  -- by Widge
##  January 2023
##
######################################################################################################

thisfile=$(echo "$PWD/"`basename "$0"`)

repo="https://github.com/Widge-5/Sinden_Lightgun_Config_Editor/archive/refs/heads/main.zip"
tmpfolder="/home/pi/slgce_install"
destfolder="/home/pi/Lightgun/utils"
sindenfolder="/home/pi/RetroPie/roms"
utilscfg="widgeutils.cfg"
title="BareBones Screen Aspect Adaptation Utility"



function rootcheck() {
  #- Script must be run as root
  if [[ $EUID > 0 ]]; then
    colourecho cLRED "ERROR: Script must be run as root: eg: \"sudo $thisfile\""
    exit 0
  else	
    return
  fi
}



function colourecho(){
    _nc="\033[0m"
    case $1 in
      cBLACK )         _col="\033[0;30m";;
      cDGRAY|cDGREY )  _col="\033[1;30m";;
      cRED )           _col="\033[0;31m";;
      cLRED )          _col="\033[1;31m";;
      cGREEN )         _col="\033[0;32m";;
      cLGREEN )        _col="\033[1;32m";;
      cBROWN|cORANGE ) _col="\033[0;33m";;
      cYELLOW )        _col="\033[1;33m";;
      cBLUE )          _col="\033[0;34m";;
      cLBLUE )         _col="\033[1;34m";;
      cPURPLE )        _col="\033[0;35m";;
      cLPURPLE )       _col="\033[1;35m";;
      cCYAN )          _col="\033[0;36m";;
      cLCYAN )         _col="\033[1;36m";;
      cLGRAY|cLGREY )  _col="\033[0;37m";;
      cWHITE )         _col="\033[1;37m";;
      cNUL|* )         _col=$nc;;
    esac
  echo -e "${_col}${2}${_nc}"
}



function downloader() {
  rm -rf $2
  mkdir $2
  cd $2
  echo "Downloading "$1"..."
  wget --timeout 15 --no-http-keep-alive --no-cache --no-cookies $3
  wait
  echo "Extracting "$1"..."
  unzip -q main.zip
}



function tidyup(){
  echo "Cleaning up...."
  cd /home/pi
  rm -rf $1
  echo "Done."
}



function dloverlays() {
  downloader "new overlays" "/home/pi/srfoverlays" "https://github.com/Widge-5/Sinden_BB_screenratio/archive/refs/heads/main.zip"
  echo "Moving new overlays to location..."
  cd "/home/pi/srfoverlays/Sinden_BB_screenratio-main/overlay"
  cp *.* /opt/retropie/configs/all/retroarch/overlay
  cd /home/pi
}


function builder() { if ! grep -Fq "$1" "$3" ; then echo "$1=\"$2\"" >> $3 ; fi ; }

function cfgmaker() {
  if [ ! -f "$destfolder/$utilscfg" ]; then
    echo > $destfolder/$utilscfg
  fi
  if  ! grep -Fq "[ CONFIG LOCATIONS ]" "$destfolder/$utilscfg" ; then
    echo "[ CONFIG LOCATIONS ] S1 & S2 are Supermodel-specific configs." >> $destfolder/$utilscfg
    echo >> $destfolder/$utilscfg
  fi
  builder "<P1normal>" "/home/pi/Lightgun/Player1/LightgunMono.exe.config" "$destfolder/$utilscfg"
  builder "<P1recoil>" "/home/pi/Lightgun/Player1recoil/LightgunMono.exe.config" "$destfolder/$utilscfg"
  builder "<P1auto>" "/home/pi/Lightgun/Player1recoilauto/LightgunMono.exe.config" "$destfolder/$utilscfg"
  builder "<P2normal>" "/home/pi/Lightgun/Player2/LightgunMono2.exe.config" "$destfolder/$utilscfg"
  builder "<P2recoil>" "/home/pi/Lightgun/Player2recoil/LightgunMono2.exe.config" "$destfolder/$utilscfg"
  builder "<P2auto>" "/home/pi/Lightgun/Player2recoilauto/LightgunMono2.exe.config" "$destfolder/$utilscfg"
  builder "<P3normal>" "/home/pi/Lightgun/Player3/LightgunMono3.exe.config" "$destfolder/$utilscfg"
  builder "<P3recoil>" "/home/pi/Lightgun/Player3recoil/LightgunMono3.exe.config" "$destfolder/$utilscfg"
  builder "<P3auto>" "/home/pi/Lightgun/Player3recoilauto/LightgunMono3.exe.config" "$destfolder/$utilscfg"
  builder "<P4normal>" "/home/pi/Lightgun/Player4recoil/LightgunMono4.exe.config" "$destfolder/$utilscfg"
  builder "<P4recoil>" "/home/pi/Lightgun/Player4recoil/LightgunMono4.exe.config" "$destfolder/$utilscfg"
  builder "<P4auto>" "/home/pi/Lightgun/Player4recoilauto/LightgunMono4.exe.config" "$destfolder/$utilscfg"
  builder "<S1normal>" "/home/pi/Lightgun/SM3_Player1/LightgunMono.exe.config" "$destfolder/$utilscfg"
  builder "<S1recoil>" "/home/pi/Lightgun/SM3_Player1recoil/LightgunMono.exe.config" "$destfolder/$utilscfg"
  builder "<S1auto>" "/home/pi/Lightgun/SM3_Player1recoilauto/LightgunMono.exe.config" "$destfolder/$utilscfg"
  builder "<S2normal>" "/home/pi/Lightgun/SM3_Player2/LightgunMono2.exe.config" "$destfolder/$utilscfg"
  builder "<S2recoil>" "/home/pi/Lightgun/SM3_Player2recoil/LightgunMono2.exe.config" "$destfolder/$utilscfg"
  echo >> $destfolder/$utilscfg
  echo >> $destfolder/$utilscfg
}


function main() {
echo $thisfile
  while true ; do
    colourecho cLCYAN  "In which location are your Sinden start scripts?"
    colourecho cLGREEN "[1] SINDEN"
    colourecho cLGREEN "[2] PORTS"
    colourecho cLGREEN "[Q] quit"
    read -N1 ans
    case "$ans" in
      1)   colourecho cLBLUE " : SINDEN"
           sindenfolder="$sindenfolder/sinden"
           break ;;
      2)   colourecho cLBLUE " : PORTS"
           sindenfolder="$sindenfolder/ports"
           break ;;
      Q|q) colourecho cLRED " : CANCELLING"
           exit;;
    esac
  done
  downloader "Config Editor for Sinden Lightgun" "$tmpfolder" "$repo"
  cd "$tmpfolder/Sinden_Lightgun_Config_Editor-main"
  chmod +x *.sh
  if [ ! -d "$destfolder" ]; then
    mkdir "$destfolder"
  fi
  cp -pf "$tmpfolder/Sinden_Lightgun_Config_Editor-main/sindenconfigedit.sh" $destfolder
  cp -pf "$tmpfolder/Sinden_Lightgun_Config_Editor-main/recoiltcs.txt" $destfolder
  cp -pf "$tmpfolder/Sinden_Lightgun_Config_Editor-main/Sinden Lightgun Config Editor.sh" $sindenfolder
  tidyup "$tmpfolder"
  cfgmaker
  colourecho cLCYAN  "Install completed"
  while true ; do
    colourecho cLCYAN  "Do you want to delete this installer?"
    colourecho cLGREEN "[Y] Yes"
    colourecho cLGREEN "[N] No"
    read -N1 ans
    case "$ans" in
      y|Y)  colourecho cLBLUE " : YES"
            /bin/rm -f "$thisfile"
            break ;;
      n|N)  colourecho cLBLUE " : NO"
            break ;;
    esac
  done
  colourecho cLRED "Now restart EmulationStation"
}



####### START #######

rootcheck
main



