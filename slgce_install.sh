#!/bin/bash

######################################################################################################
##
##  Installer for "Config Editor for Sinden Lightgun"
##  -- by Widge
##  January 2023
##
######################################################################################################

repo="https://github.com/Widge-5/Sinden_Lightgun_Config_Editor/archive/refs/heads/main.zip"
tmpfolder="/home/pi/slgce_install"
destfolder="/home/pi/Lightgun/configedit"
sindenfolder="/home/pi/RetroPie/roms"
thisfile=$(echo "$PWD/"`basename "$0"`)

title="BareBones Screen Aspect Adaptation Utility (v1.02)"

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
  mkdir "$destfolder"
  cp -pf "$tmpfolder/Sinden_Lightgun_Config_Editor-main/sindenconfigedit.sh" $destfolder
  cp -pf "$tmpfolder/Sinden_Lightgun_Config_Editor-main/tsandcs.txt" $destfolder
  cp -pf "$tmpfolder/Sinden_Lightgun_Config_Editor-main/Sinden Lightgun Config Editor.sh" $sindenfolder
  tidyup "$tmpfolder"

  colourecho cLCYAN  "Install completed"
  while true ; do
    colourecho cLCYAN  "Do you want to delete this instaler?"
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

main
