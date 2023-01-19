#!/bin/bash

######################################################################
##
##   Config Editor for Sinden Lightgun
##   v1.07    January 2023
##   -- By Widge
##
##   For use with Sinden v1.8 config files
##
######################################################################



###########################
############  GLOBAL ######
###########################

backtitle="Config Editor for Sinden Lightgun v1.07 -- By Widge"
utilscfg="/home/pi/Lightgun/utils/widgeutils.cfg"

function grabber(){ grep "$1" "$2" | grep -o '".*"' | sed 's/"//g' ; }

name_P1_norm="Player1 - NoRecoil"
name_P1_reco="Player1 - SingleRecoil"
name_P1_auto="Player1 - AutoRecoil"
name_P2_norm="Player2 - NoRecoil"
name_P2_reco="Player2 - SingleRecoil"
name_P2_auto="Player2 - AutoRecoil"
name_P3_norm="Player3 - NoRecoil"
name_P3_reco="Player3 - SingleRecoil"
name_P3_auto="Player3 - AutoRecoil"
name_P4_norm="Player4 - NoRecoil"
name_P4_reco="Player4 - SingleRecoil"
name_P4_auto="Player4 - AutoRecoil"
name_S1_norm="Player1 Supermodel - NoRecoil"
name_S1_reco="Player1 Supermodel - SingleRecoil"
name_S1_auto="Player1 Supermodel - AutoRecoil"
name_S2_norm="Player2 Supermodel - NoRecoil"
name_S2_reco="Player2 Supermodel - SingleRecoil"
name_S2_auto="Player2 Supermodel - AutoRecoil"


cfg_P1_norm=$(grabber "<P1normal>" "$utilscfg")
cfg_P1_reco=$(grabber "<P1recoil>" "$utilscfg")
cfg_P1_auto=$(grabber "<P1auto>" "$utilscfg")
cfg_P2_norm=$(grabber "<P2normal>" "$utilscfg")
cfg_P2_reco=$(grabber "<P2recoil>" "$utilscfg")
cfg_P2_auto=$(grabber "<P2auto>" "$utilscfg")
cfg_P3_norm=$(grabber "<P3normal>" "$utilscfg")
cfg_P3_reco=$(grabber "<P3recoil>" "$utilscfg")
cfg_P3_auto=$(grabber "<P3auto>" "$utilscfg")
cfg_P4_norm=$(grabber "<P4normal>" "$utilscfg")
cfg_P4_reco=$(grabber "<P4recoil>" "$utilscfg")
cfg_P4_auto=$(grabber "<P4auto>" "$utilscfg")
cfg_S1_norm=$(grabber "<S1normal>" "$utilscfg")
cfg_S1_reco=$(grabber "<S1recoil>" "$utilscfg")
cfg_S1_auto=$(grabber "<S1auto>" "$utilscfg")
cfg_S2_norm=$(grabber "<S2normal>" "$utilscfg")
cfg_S2_reco=$(grabber "<S2recoil>" "$utilscfg")
cfg_S2_auto=$(grabber "<S2auto>" "$utilscfg")



function prep() {
  /opt/retropie/admin/joy2key/joy2key start
}

function post() {
  /opt/retropie/admin/joy2key/joy2key stop
  dialog --infobox "\nRestart your guns for any changes to take effect." 5 55 3>&1 1>&2 2>&3
  sleep 3
  clear
}

function filecheck() {
  if ! test -f "$1"; then
    dialog --title "$title" --backtitle "$backtitle" --msgbox "\nThe selected file doesn't exist.\n\n$1" 10 70 3>&1 1>&2 2>&3
    echo "no"
  else
    echo "yes"
  fi
}


function areyousure() {
  dialog --defaultno --title "Are you sure?" --backtitle "$backtitle" --yesno "\nAre you sure you want to $1" 10 70 3>&1 1>&2 2>&3
  echo $?
}

function applychange () {
  sed -i -e "/.*${2}/s/value=\".*\"/value=\"${3}\"/" ${1}
}


function getvalues() {
  grep $1 $sourcefile | grep -o 'value=".*"' | sed 's/value="//g' | sed 's/"//g'
}


function onoffread(){ if [ $2 $1 = "1" ]; then echo "on"; else echo "off"; fi }

function onoffwrite() { if [ ! $1 = "1" ]; then echo "1"; else echo "0"; fi }
 
function radiocomparison()  { if [ $1 = $2 ]; then echo "on"; else echo "off"; fi }


function rangeentry(){
  local title="$1"
  selection=$(dialog --title "$title" --backtitle "$backtitle" --nocancel --rangebox \
  "\nSet the value of the $1.\n\n$5(Current setting : $4)" \
  11 50 $2 $3 $4 3>&1 1>&2 2>&3 )
    echo $selection
}



function captivedialog { # usage: captivedialog [duration(s)] [height] [width] [message] [title]
  local count=$1+1
  local percent
  local yn
  (( ++count )) 
  ( while :; do
      cat <<-EOF      # The "-" here allows EOF later to be indented with TAB
        $percent
	EOF
      (( count-=1 ))  # This can only be indented with TAB
      percent=$((100/$1*($1+2-$count)))
      [ $count -eq 0 ] && break
      sleep 0.1
    done ) |
    dialog --title "$5" --gauge "$4" $2 $3 $percent
    dialog --title "$5" --yes-label " OK " --no-label " Go Back " --yesno "$4" $2 $3
    captivereturn=$?
}


function choosefile() { # [title] [message]
  local selection
  local choicecfg
  local choicename
  local yn
  local destfile
  selection=$(dialog --title "$1" --backtitle "$backtitle" --menu "$2" 28 70 18 \
      "1"   "$name_P1_norm" \
      "2"   "$name_P1_reco" \
      "3"   "$name_P1_auto" \
      "4"   "$name_P2_norm" \
      "5"   "$name_P2_reco" \
      "6"   "$name_P2_auto" \
      "7"   "$name_P3_norm" \
      "8"   "$name_P3_reco" \
      "9"   "$name_P3_auto" \
      "10"  "$name_P4_norm" \
      "11"  "$name_P4_reco" \
      "12"  "$name_P4_auto" \
      "13"  "$name_S1_norm" \
      "14"  "$name_S1_reco" \
      "15"  "$name_S1_auto" \
      "16"  "$name_S2_norm" \
      "17"  "$name_S2_reco" \
      "18"  "$name_S2_auto" \
      3>&1 1>&2 2>&3 )
      case "$selection" in
          1)   choicecfg=$cfg_P1_norm ;  choicename=$name_P1_norm ;;
          2)   choicecfg=$cfg_P1_reco ;  choicename=$name_P1_reco ;;
          3)   choicecfg=$cfg_P1_auto ;  choicename=$name_P1_auto ;;
          4)   choicecfg=$cfg_P2_norm ;  choicename=$name_P2_norm ;;
          5)   choicecfg=$cfg_P2_reco ;  choicename=$name_P2_reco ;;
          6)   choicecfg=$cfg_P2_auto ;  choicename=$name_P2_auto ;;
          7)   choicecfg=$cfg_P3_norm ;  choicename=$name_P3_norm ;;
          8)   choicecfg=$cfg_P3_reco ;  choicename=$name_P3_reco ;;
          9)   choicecfg=$cfg_P3_auto ;  choicename=$name_P3_auto ;;
          10)  choicecfg=$cfg_P4_norm ;  choicename=$name_P4_norm ;;
          11)  choicecfg=$cfg_P4_reco ;  choicename=$name_P4_reco ;;
          12)  choicecfg=$cfg_P4_auto ;  choicename=$name_P4_auto ;;
          13)  choicecfg=$cfg_S1_norm ;  choicename=$name_S1_norm ;;
          14)  choicecfg=$cfg_S1_reco ;  choicename=$name_S1_reco ;;
          15)  choicecfg=$cfg_S1_auto ;  choicename=$name_S1_auto ;;
          16)  choicecfg=$cfg_S2_norm ;  choicename=$name_S2_norm ;;
          17)  choicecfg=$cfg_S2_reco ;  choicename=$name_S2_reco ;;
          18)  choicecfg=$cfg_S2_auto ;  choicename=$name_S2_auto ;;
          *)   return ;;
        esac
     if ! [ "$choicename" = "" ]; then
       dialog --title "Your Selection..." --msgbox "\n$choicename\n$choicecfg" 10 70
       selfile="$choicecfg"
       selname="$choicename"
     else
       dialog --title "Your Selection..." --msgbox "\nVoid config selected. Cancelling" 10 70
       selfile=""
       selname=""
       return
     fi
}



function settingstransfer() {
  local title
  local selection
  local yn
  local destname
  local destfile
  title="Destination for $1 Settings Transfer"
  choosefile "$title" "\nChoose Which config file you would like to copy these settings into.\n\nBe careful to make the correct selection and ensure that you have made backups of your configs."
  destfile=$selfile
  destname=$selname
     if ! [ "$destname" = "" ]; then
         settingstransfer_2 "$1" "$sourcefile" "$destfile"
     else
       return
     fi
}



function settingstransfer_2() { 
local yn
yn=$(areyousure "go through with this transfer?")
  if [ $yn == "0" ]; then
    case "$1" in
      "Button Map") 
         buttonprep
         savebuttons $3
         dialog --title "$1" --backtitle "$backtitle" --no-cancel --msgbox "\nTransfer Complete"  7 22
         ;;
      "Recoil")
         recoilprep
         saverecoil $3
         dialog --title "$1" --backtitle "$backtitle" --no-cancel --msgbox "\nTransfer Complete"  7 22
         ;;
      "Camera")
         cameraprep
         savecamera $3
         dialog --title "$1" --backtitle "$backtitle" --no-cancel --msgbox "\nTransfer Complete"  7 22
         ;;
      *) dialog --msgbox "ERROR"  15 70 ;;
    esac
  else
    dialog --msgbox "\nTransfer Cancelled"  7 23
  fi  
}



###########################
############  RECOIL ######
###########################

function saverecoil() {
  applychange $1 $s_agreeterms     $v_agreeterms    
  applychange $1 $s_enablerecoil   $v_enablerecoil

  applychange $1 $s_rectrigger     $v_rectrigger
  applychange $1 $s_rectriggeros   $v_rectriggeros
  applychange $1 $s_recpumpon      $v_recpumpon   
  applychange $1 $s_recpumpoff     $v_recpumpoff  

  applychange $1 $s_recfl          $v_recfl
  applychange $1 $s_recfr          $v_recfr
  applychange $1 $s_recbl          $v_recbl
  applychange $1 $s_recbr          $v_recbr

  applychange $1 $s_singlestrength $v_singlestrength
  applychange $1 $s_recoiltype     $v_recoiltype
  applychange $1 $s_autostrength   $v_autostrength
  applychange $1 $s_autodelay      $v_autodelay
  applychange $1 $s_autopulse      $v_autopulse
}




function recoilprep() {
  s_agreeterms="\"IAgreeRecoilTermsInLicense\"" ;  v_agreeterms="0"
  s_enablerecoil="\"EnableRecoil\""             ;  v_enablerecoil=$(getvalues $s_enablerecoil)

  s_rectrigger="\"RecoilTrigger\""              ;  v_rectrigger=$(getvalues $s_rectrigger)
  s_rectriggeros="\"RecoilTriggerOffscreen\""   ;  v_rectriggeros=$(getvalues $s_rectriggeros)
  s_recpumpon="\"RecoilPumpActionOnEvent\""     ;  v_recpumpon=$(getvalues $s_recpumpon)
  s_recpumpoff="\"RecoilPumpActionOffEvent\""   ;  v_recpumpoff=$(getvalues $s_recpumpoff)

  s_recfl="\"RecoilFrontLeft\""                 ;  v_recfl=$(getvalues $s_recfl)
  s_recfr="\"RecoilFrontRight\""                ;  v_recfr=$(getvalues $s_recfr)
  s_recbl="\"RecoilBackLeft\""                  ;  v_recbl=$(getvalues $s_recbl)
  s_recbr="\"RecoilBackRight\""                 ;  v_recbr=$(getvalues $s_recbr)

  s_singlestrength="\"RecoilStrength\""         ;  v_singlestrength=$(getvalues $s_singlestrength)

  s_recoiltype="\"TriggerRecoilNormalOrRepeat\"";  v_recoiltype=$(getvalues $s_recoiltype)

  s_autostrength="\"AutoRecoilStrength\""       ;  v_autostrength=$(getvalues $s_autostrength)
  s_autodelay="\"AutoRecoilStartDelay\""        ;  v_autodelay=$(getvalues $s_autodelay)
  s_autopulse="\"AutoRecoilDelayBetweenPulses\"";  v_autopulse=$(getvalues $s_autopulse)
}



function termsandcond(){ 
  local licensetxt
  local title
  licensetxt="/home/pi/Lightgun/utils/recoiltcs.txt"
  title="Recoil Terms and Conditions"
  dialog --defaultno --scrollbar --yes-label " Accept " --no-label " Cancel " \
    --title "$title" --backtitle "$backtitle" --yesno "$(head -c 3K $licensetxt)"  35 70 3>&1 1>&2 2>&3
  local RET=$?
  if [ $RET -eq 0 ]; then
    v_agreeterms=1
    recoilmenuitem=3
    return 0
  else
    recoilmenuitem=9
  fi  
}



function recoilvalues() {
  local title
  local selection
  title="Recoil Type and Intensity Values"
  if [ $v_recoiltype == "0" ]; then
    n_recoiltype="Single";
  elif [ $v_recoiltype == "1" ]; then
    n_recoiltype="Auto";
  else
    n_recoiltype="unknown"
  fi
  selection=$(dialog --cancel-label " Back " --title "$title" --backtitle "$backtitle" --menu \
    "\nChoose which setting you want to edit.\nThe current value is shown alongside the option." \
    20 70 6 \
      "1"  "Recoil Type ($n_recoiltype)" \
      "2"  "Single Recoil Strength ($v_singlestrength)" \
      "3"  "Auto Recoil Strength ($v_autostrength)" \
      "4"  "Auto Start Delay ($v_autodelay)" \
      "5"  "Auto Pulse Delay ($v_autopulse)" \
      3>&1 1>&2 2>&3 )
    case "$selection" in
      1)
        f_recoiltype
	recoilmenuitem=5
      ;;
      2)
        v_singlestrength=$(rangeentry "Single-Shot Recoil" 0 100 $v_singlestrength \
          "Note that higher values drain the capacitor quicker and will take longer to recharge.\n\n")
	recoilmenuitem=5
      ;;
      3)
        v_autostrength=$(rangeentry "Automatic Recoil" 0 100 $v_autostrength \
          "Note that higher values drain the capacitor quicker and will take longer to recharge.\n\n")
	recoilmenuitem=5
      ;;
      4)
        v_autodelay=$(rangeentry "Automatic Recoil Start Delay" 0 30000 $v_autodelay \
          "This is the time between the first recoil and the subsequent repeated pulse\n\n")
	recoilmenuitem=5
      ;;
      5)
        v_autopulse=$(rangeentry "Automatic Recoil Pulse Delay" 0 30000 $v_autopulse \
          "This is the time between the first recoil and the subsequent repeated pulse\n\nNote that more rapid recoil (lower values) can drain the capacitor quicker if it has insufficient time to recharge.\n\n")
	recoilmenuitem=5
      ;;
      *)
	recoilmenuitem=3
      ;;
    esac
}




function f_recoiltype(){
  local title
  local selection
  title="Recoil Type"
  selection=$(dialog --title "$title" --backtitle "$backtitle" --nocancel --radiolist \
    "\nChoose the type of recoil you want to use.\nCurrent setting : $n_recoiltype" \
    20 70 2\
      "1"  "Single" $(onoffread $v_recoiltype !) \
      "2"  "Auto"   $(onoffread $v_recoiltype) \
      3>&1 1>&2 2>&3 )
    case "$selection" in
      1) v_recoiltype="0" ;;
      2) v_recoiltype="1" ;;
    esac
}



function recoilbuttons(){
  local title
  local selection
  title="Buttons That Use Recoil"
  selection=$(dialog --title "$title" --backtitle "$backtitle" --nocancel --checklist \
    "\nChoose which buttons will cause the recoil solenoid to fire." \
    20 70 8 \
      "1"  "Trigger"             $(onoffread $v_rectrigger) \
      "2"  "Trigger offscreen"   $(onoffread $v_rectriggeros) \
      "3"  "Pump"                $(onoffread $v_recpumpon) \
      "4"  "Pump Release"        $(onoffread $v_recpumpoff) \
      "5"  "Front Left"          $(onoffread $v_recfl) \
      "6"  "Front Right"         $(onoffread $v_recfr) \
      "7"  "Back Left"           $(onoffread $v_recbl) \
      "8"  "Back Right"          $(onoffread $v_recbr) \
      3>&1 1>&2 2>&3 )
  if grep -q "1" <<< "$selection"; then v_rectrigger="1";   else v_rectrigger="0";   fi
  if grep -q "2" <<< "$selection"; then v_rectriggeros="1"; else v_rectriggeros="0"; fi
  if grep -q "3" <<< "$selection"; then v_recpumpon="1";    else v_recpumpon="0"; fi
  if grep -q "4" <<< "$selection"; then v_recpumpoff="1";   else v_recpumpoff="0"; fi
  if grep -q "5" <<< "$selection"; then v_recfl="1";        else v_recfl="0"; fi
  if grep -q "6" <<< "$selection"; then v_recfr="1";        else v_recfr="0"; fi
  if grep -q "7" <<< "$selection"; then v_recbl="1";        else v_recbl="0"; fi
  if grep -q "8" <<< "$selection"; then v_recbr="1";        else v_recbr="0"; fi
}



function recoilmenu(){
  local title
  local selection
  local yn
  title="Recoil Main Menu"
  selection=$(dialog --cancel-label " Quit without saving " --title "$title" --backtitle "$backtitle" --menu \
      "\n$sourcename\n\n$sourcefile\n\nWhich recoil settings would you like to view and edit?" \
      20 70 6 \
      "1"  "Enable/disable recoil ($(onoffread $v_enablerecoil))" \
      "2"  "Enable/disable which buttons should use recoil." \
      "3"  "Recoil type and intensity." \
      "4"  "Transfer this file's settings to another config file" \
      "5"  "Save changes and exit." \
      "6"  "Withdraw agreement to the terms of use." \
      3>&1 1>&2 2>&3 )
        case "$selection" in
          1) v_enablerecoil=$(onoffwrite $v_enablerecoil) ;;
          2) recoilmenuitem=4 ;;
          3) recoilmenuitem=5 ;;
          4) settingstransfer "Recoil" ;;
          5) yn=$(areyousure "overwrite your $sourcename config file with the selections you have made?")
             if [ $yn == "0" ]; then
               saverecoil $sourcefile
               dialog --backtitle "$backtitle" --title "Save Complete" --msgbox "\nRecoil changes have been saved for $sourcename." 12 78
               recoilmenuitem=9
             else
               recoilmenuitem=3
             fi ;;
          6) yn=$(areyousure "withdraw your agreement to the terms of the licence? This will disable recoil functionality.")
             if [ $yn == "0" ]; then
               applychange $s_agreeterms   0 $sourcefile
               recoilprep
               saverecoil
               recoilmenuitem=2
             else
               recoilmenuitem=3
             fi ;;
          *) recoilmenuitem=9
        esac
}



function recoilchoosefile() {
  local title
  local selection
  title="Recoil Config File Selection"
  choosefile "$title" "\nWhich config file would you like to view and edit?"
  sourcefile=$selfile
  sourcename=$selname
     if ! [ "$sourcename" = "" ] && [ $(filecheck $sourcefile) == "yes" ]; then
         recoilmenuitem=1
     else
         recoilmenuitem=9
     fi
}



function recoilmain(){
  recoilmenuitem=0
  while ! [[ $recoilmenuitem -eq 9 ]]; do
    case "$recoilmenuitem" in
      0) recoilchoosefile ;;
      1) recoilprep
         recoilmenuitem=2 ;;
      2) termsandcond ;;
      3) recoilmenu ;;
      4) recoilbuttons
         recoilmenuitem=3 ;;
      5) recoilvalues ;;
      9|*) return ;;
    esac
  done
}



###########################
############  CAMERA ######
###########################


function cameraprep() {
  s_brightness="\"CameraBrightness\""      ;  v_brightness=$(getvalues $s_brightness)
  s_contrast="\"CameraContrast\""          ;  v_contrast=$(getvalues $s_contrast)
  s_expauto="\"CameraExposureAuto\""       ;  v_expauto=$(getvalues $s_expauto)
  s_exposure="\"CameraExposure\""          ;  v_exposure=$(getvalues $s_exposure)
  s_saturation="\"CameraSaturation\""      ;  v_saturation=$(getvalues $s_saturation)
  s_colourrange="\"ColourMatchRange\""     ;  v_colourrange=$(getvalues $s_colourrange)
  s_whiteauto="\"CameraWhiteBalanceAuto\"" ;  v_whiteauto=$(getvalues $s_whiteauto)
  s_whitebalance="\"CameraWhiteBalance\""  ;  v_whitebalance=$(getvalues $s_whitebalance)
}


function savecamera() {
  applychange $1 $s_brightness     $v_brightness
  applychange $1 $s_contrast       $v_contrast  
  applychange $1 $s_expauto        $v_expauto   
  applychange $1 $s_saturation     $v_saturation
  applychange $1 $s_colourrange    $v_colourrange
  applychange $1 $s_whiteauto      $v_whiteauto  
  applychange $1 $s_whitebalance   $v_whitebalance
  applychange $1 $s_exposure       $v_exposure  
}


function cameramenu() {
  local title
  local selection
  local yn
  title="Camera Settings"
  if [ $v_expauto = "1" ]; then v_exposure=""; fi
  selection=$(dialog --cancel-label " Quit without saving " --title "$title" --backtitle "$backtitle" --menu \
    "\nChoose which setting you want to edit.\nThe current value is shown alongside the option." \
    20 70 10 \
      "1"  "Brightness ($v_brightness)" \
      "2"  "Contrast ($v_contrast)" \
      "3"  "Auto Exposure ($(onoffread $v_expauto))" \
      "4"  "Manual Exposure ($v_exposure)" \
      "5"  "Saturation ($v_saturation)" \
      "6"  "Colour Match Range ($v_colourrange)" \
      "7"  "Auto White Balance ($(onoffread $v_whiteauto))" \
      "8"  "Manual White Balance ($v_whitebalance)" \
      "9"  "Transfer this file's settings to another config file" \
      "10" "Save changes" \
      3>&1 1>&2 2>&3 )
    case "$selection" in
      1) v_brightness=$(rangeentry "Camera Brightness" 0 255 $v_brightness) ;;
      2) v_contrast=$(rangeentry "Camera Contrast" 0 127 $v_contrast) ;;
      3) v_expauto=$(onoffwrite $v_expauto) ;;
      4) if [ $v_expauto = "0" ]; then 
           if [ -z "$v_exposure" ]; then v_exposure="-5"; fi
           v_exposure=$(rangeentry "Camera Manual Exposure" -9 0 $v_exposure "This value will be blank if Auto Exposure is on.\n\n")
         fi ;;
      5) v_saturation=$(rangeentry "Camera Saturation" 0 512 $v_saturation) ;;
      6) v_colourrange=$(rangeentry "Camera Colour Match Range" 0 512 $v_colourrange "Slight increases to this value can sometimes help with border recognition.\n\n") ;;
      7) v_whiteauto=$(onoffwrite $v_whiteauto) ;;
      8) v_whitebalance=$(rangeentry "Camera Manual White Balance" 2800 6500 $v_whitebalance) ;;
      9) settingstransfer "Camera" ;;
      10) yn=$(areyousure "overwrite your $sourcename config file with the selections you have made?")
             if [ $yn == "0" ]; then
               savecamera $sourcefile
               dialog --backtitle "$backtitle" --title "Save Complete" --msgbox "\nCamera changes have been saved for $sourcename." 12 78
               cameramenuitem=9
             fi ;;
      *) cameramenuitem=9
         return ;;
    esac
}



function camerachoosefile(){
  local title
  local selection
  title="Camera Config File Selection ($1)"
  choosefile "$title" "\nWhich config file would you like to view and edit?"
  sourcefile=$selfile
  sourcename=$selname
     if ! [ "$sourcename" = "" ] && [ $(filecheck $sourcefile) == "yes" ]; then
         cameramenuitem=1
     else
         cameramenuitem=9
     fi
}



function cameramain(){
  cameramenuitem=0
  while ! [[ $cameramenuitem -eq 9 ]]; do
    case "$cameramenuitem" in
      0) camerachoosefile ;;
      1) cameraprep
         cameramenuitem=5 ;;
      5) cameramenu;;
     9|*) return ;;
    esac
  done
}




#############################
############  BUTTON  ######
###########################




function buttonprep() {
  s_ontrigger="\"ButtonTrigger\""           ;   v_ontrigger=$(getvalues $s_ontrigger)
  s_onpump="\"ButtonPumpAction\""           ;   v_onpump=$(getvalues $s_onpump)
  s_onfl="\"ButtonFrontLeft\""              ;   v_onfl=$(getvalues $s_onfl)
  s_onbl="\"ButtonRearLeft\""               ;   v_onbl=$(getvalues $s_onbl)
  s_onfr="\"ButtonFrontRight\""             ;   v_onfr=$(getvalues $s_onfr)
  s_onbr="\"ButtonRearRight\""              ;   v_onbr=$(getvalues $s_onbr)
  s_onup="\"ButtonUp\""                     ;   v_onup=$(getvalues $s_onup)
  s_ondown="\"ButtonDown\""                 ;   v_ondown=$(getvalues $s_ondown)
  s_onleft="\"ButtonLeft\""                 ;   v_onleft=$(getvalues $s_onleft)
  s_onright="\"ButtonRight\""               ;   v_onright=$(getvalues $s_onright)

  s_onmodtrigger="\"TriggerMod\""           ;   v_onmodtrigger=$(getvalues $s_onmodtrigger)
  s_onmodpump="\"PumpActionMod\""           ;   v_onmodpump=$(getvalues $s_onmodpump)
  s_onmodfl="\"FrontLeftMod\""              ;   v_onmodfl=$(getvalues $s_onmodfl)
  s_onmodbl="\"RearLeftMod\""               ;   v_onmodbl=$(getvalues $s_onmodbl)
  s_onmodfr="\"FrontRightMod\""             ;   v_onmodfr=$(getvalues $s_onmodfr)
  s_onmodbr="\"RearRightMod\""              ;   v_onmodbr=$(getvalues $s_onmodbr)
  s_onmodup="\"UpMod\""                     ;   v_onmodup=$(getvalues $s_onmodup)
  s_onmoddown="\"DownMod\""                 ;   v_onmoddown=$(getvalues $s_onmoddown)
  s_onmodleft="\"LeftMod\""                 ;   v_onmodleft=$(getvalues $s_onmodleft)
  s_onmodright="\"RightMod\""               ;   v_onmodright=$(getvalues $s_onmodright)

  s_offtrigger="\"ButtonTriggerOffscreen\"" ;   v_offtrigger=$(getvalues $s_offtrigger)
  s_offpump="\"ButtonPumpActionOffscreen\"" ;   v_offpump=$(getvalues $s_offpump)
  s_offfl="\"ButtonFrontLeftOffscreen\""    ;   v_offfl=$(getvalues $s_offfl)
  s_offbl="\"ButtonRearLeftOffscreen\""     ;   v_offbl=$(getvalues $s_offbl)
  s_offfr="\"ButtonFrontRightOffscreen\""   ;   v_offfr=$(getvalues $s_offfr)
  s_offbr="\"ButtonRearRightOffscreen\""    ;   v_offbr=$(getvalues $s_offbr)
  s_offup="\"ButtonUpOffscreen\""           ;   v_offup=$(getvalues $s_offup)
  s_offdown="\"ButtonDownOffscreen\""       ;   v_offdown=$(getvalues $s_offdown)
  s_offleft="\"ButtonLeftOffscreen\""       ;   v_offleft=$(getvalues $s_offleft)
  s_offright="\"ButtonRightOffscreen\""     ;   v_offright=$(getvalues $s_offright)

  s_offmodtrigger="\"TriggerOffscreenMod\"" ;   v_offmodtrigger=$(getvalues $s_offmodtrigger)
  s_offmodpump="\"PumpActionOffscreenMod\"" ;   v_offmodpump=$(getvalues $s_offmodpump)
  s_offmodfl="\"FrontLeftOffscreenMod\""    ;   v_offmodfl=$(getvalues $s_offmodfl)
  s_offmodbl="\"RearLeftOffscreenMod\""     ;   v_offmodbl=$(getvalues $s_offmodbl)
  s_offmodfr="\"FrontRightOffscreenMod\""   ;   v_offmodfr=$(getvalues $s_offmodfr)
  s_offmodbr="\"RearRightOffscreenMod\""    ;   v_offmodbr=$(getvalues $s_offmodbr)
  s_offmodup="\"UpOffscreenMod\""           ;   v_offmodup=$(getvalues $s_offmodup)
  s_offmoddown="\"DownOffscreenMod\""       ;   v_offmoddown=$(getvalues $s_offmoddown)
  s_offmodleft="\"LeftOffscreenMod\""       ;   v_offmodleft=$(getvalues $s_offmodleft)
  s_offmodright="\"RightOffscreenMod\""     ;   v_offmodright=$(getvalues $s_offmodright)

  s_enableoffscreen="\"OffscreenReload\""   ;   v_enableoffscreen=$(getvalues $s_enableoffscreen=)
}


function savebuttons() { 
  applychange $1 $s_ontrigger $v_ontrigger
  applychange $1 $s_onpump $v_onpump
  applychange $1 $s_onfl $v_onfl
  applychange $1 $s_onbl $v_onbl
  applychange $1 $s_onfr $v_onfr
  applychange $1 $s_onbr $v_onbr
  applychange $1 $s_onup $v_onup
  applychange $1 $s_ondown $v_ondown
  applychange $1 $s_onleft $v_onleft
  applychange $1 $s_onright $v_onright
  applychange $1 $s_onmodtrigger $v_onmodtrigger
  applychange $1 $s_onmodpump $v_onmodpump
  applychange $1 $s_onmodfl $v_onmodfl
  applychange $1 $s_onmodbl $v_onmodbl
  applychange $1 $s_onmodfr $v_onmodfr
  applychange $1 $s_onmodbr $v_onmodbr
  applychange $1 $s_onmodup $v_onmodup
  applychange $1 $s_onmoddown $v_onmoddown
  applychange $1 $s_onmodleft $v_onmodleft
  applychange $1 $s_onmodright $v_onmodright
  applychange $1 $s_offtrigger $v_offtrigger
  applychange $1 $s_offpump $v_offpump
  applychange $1 $s_offfl $v_offfl
  applychange $1 $s_offbl $v_offbl
  applychange $1 $s_offfr $v_offfr
  applychange $1 $s_offbr $v_offbr
  applychange $1 $s_offup $v_offup
  applychange $1 $s_offdown $v_offdown
  applychange $1 $s_offleft $v_offleft
  applychange $1 $s_offright $v_offright
  applychange $1 $s_offmodtrigger $v_offmodtrigger
  applychange $1 $s_offmodpump $v_offmodpump
  applychange $1 $s_offmodfl $v_offmodfl
  applychange $1 $s_offmodbl $v_offmodbl
  applychange $1 $s_offmodfr $v_offmodfr
  applychange $1 $s_offmodbr $v_offmodbr
  applychange $1 $s_offmodup $v_offmodup
  applychange $1 $s_offmoddown $v_offmoddown
  applychange $1 $s_offmodleft $v_offmodleft
  applychange $1 $s_offmodright $v_offmodright
}



function buttonselector(){
  local title
  local selection
  title="Button Action Selection for $1 "
  while :; do
    selection=$(dialog --no-cancel --title "$title" --backtitle "$backtitle" --radiolist \
      "\nWhat action would you like the $1 button to do?\n\nCurrent setting : $2"  \
      20 70 10 \
      "0"   "VOID"            "$(radiocomparison $2 "0")" \
      "1"   "MOUSE 1"         "$(radiocomparison $2 "1")" \
      "2"   "MOUSE 2"         "$(radiocomparison $2 "2")" \
      "3"   "MOUSE 3"         "$(radiocomparison $2 "3")" \
      "7"   "Left ALT"        "$(radiocomparison $2 "7")" \
      "8"   "Num 0"           "$(radiocomparison $2 "8")" \
      "9"   "Num 1"           "$(radiocomparison $2 "9")" \
      "10"  "Num 2"           "$(radiocomparison $2 "10")" \
      "11"  "Num 3"           "$(radiocomparison $2 "11")" \
      "12"  "Num 4"           "$(radiocomparison $2 "12")" \
      "13"  "Num 5"           "$(radiocomparison $2 "13")" \
      "14"  "Num 6"           "$(radiocomparison $2 "14")" \
      "15"  "Num 7"           "$(radiocomparison $2 "15")" \
      "16"  "Num 8"           "$(radiocomparison $2 "16")" \
      "17"  "Num 9"           "$(radiocomparison $2 "17")" \
      "18"  "Left SHIFT"      "$(radiocomparison $2 "18")" \
      "44"  "a"               "$(radiocomparison $2 "44")" \
      "45"  "b"               "$(radiocomparison $2 "45")" \
      "46"  "c"               "$(radiocomparison $2 "46")" \
      "47"  "d"               "$(radiocomparison $2 "47")" \
      "48"  "e"               "$(radiocomparison $2 "48")" \
      "49"  "f"               "$(radiocomparison $2 "49")" \
      "50"  "g"               "$(radiocomparison $2 "50")" \
      "51"  "h"               "$(radiocomparison $2 "51")" \
      "52"  "i"               "$(radiocomparison $2 "52")" \
      "53"  "j"               "$(radiocomparison $2 "53")" \
      "54"  "k"               "$(radiocomparison $2 "54")" \
      "55"  "l"               "$(radiocomparison $2 "55")" \
      "56"  "m"               "$(radiocomparison $2 "56")" \
      "57"  "n"               "$(radiocomparison $2 "57")" \
      "58"  "o"               "$(radiocomparison $2 "58")" \
      "59"  "p"               "$(radiocomparison $2 "59")" \
      "60"  "q"               "$(radiocomparison $2 "60")" \
      "61"  "r"               "$(radiocomparison $2 "61")" \
      "62"  "s"               "$(radiocomparison $2 "62")" \
      "63"  "t"               "$(radiocomparison $2 "63")" \
      "64"  "u"               "$(radiocomparison $2 "64")" \
      "65"  "v"               "$(radiocomparison $2 "65")" \
      "66"  "w"               "$(radiocomparison $2 "66")" \
      "67"  "x"               "$(radiocomparison $2 "67")" \
      "68"  "y"               "$(radiocomparison $2 "68")" \
      "69"  "z"               "$(radiocomparison $2 "69")" \
      "70"  "ENTER"           "$(radiocomparison $2 "70")" \
      "71"  "SPACE"           "$(radiocomparison $2 "71")" \
      "72"  "ESC"             "$(radiocomparison $2 "72")" \
      "73"  "TAB"             "$(radiocomparison $2 "73")" \
      "74"  "UP"              "$(radiocomparison $2 "74")" \
      "75"  "DOWN"            "$(radiocomparison $2 "75")" \
      "76"  "LEFT"            "$(radiocomparison $2 "76")" \
      "77"  "RIGHT"           "$(radiocomparison $2 "77")" \
      "78"  "\"=\" (equals)"  "$(radiocomparison $2 "78")" \
      "79"  "\",\" (comma)"   "$(radiocomparison $2 "79")" \
      "80"  "\"-\" (minus)"   "$(radiocomparison $2 "80")" \
      "81"  "\".\" (dot)"     "$(radiocomparison $2 "81")" \
      "82"  "F1"              "$(radiocomparison $2 "82")" \
      "83"  "F2"              "$(radiocomparison $2 "83")" \
      "84"  "F3"              "$(radiocomparison $2 "84")" \
      "85"  "F4"              "$(radiocomparison $2 "85")" \
      "86"  "F5"              "$(radiocomparison $2 "86")" \
      "87"  "F6"              "$(radiocomparison $2 "87")" \
      "88"  "F7"              "$(radiocomparison $2 "88")" \
      "89"  "F8"              "$(radiocomparison $2 "89")" \
      "90"  "F9"              "$(radiocomparison $2 "90")" \
      "91"  "F10"             "$(radiocomparison $2 "91")" \
      "92"  "F11"             "$(radiocomparison $2 "92")" \
      "93"  "F12"             "$(radiocomparison $2 "93")" \
      3>&1 1>&2 2>&3 )
    if ((selection >= 0 && selection <= 93)); then
      echo $selection
      return
    fi
  done
}




function buttonsonscreen() {
  local title
  local selection
  title="Button Mapping for Normal (On-Screen) Actions"
  while :; do
    selection=$(dialog --cancel-label " Back " --title "$title" --backtitle "$backtitle" --menu \
      "\nChoose which button you want to edit.\nThe current value is shown alongside the option." \
      20 70 10 \
        "1"  "Trigger ($v_ontrigger)" \
        "2"  "Pump ($v_onpump)" \
        "3"  "Front Left ($v_onfl)" \
        "4"  "Rear Left ($v_onbl)" \
        "5"  "Front Right ($v_onfr)" \
        "6"  "Rear Right ($v_onbr)" \
        "7"  "D-Pad Up ($v_onup)" \
        "8"  "D-Pad Down ($v_ondown)" \
        "9"  "D-Pad Left ($v_onleft)" \
       "10"  "D-Pad Right ($v_onright)" \
        3>&1 1>&2 2>&3 )
    case "$selection" in
      1) v_ontrigger=$(buttonselector "Trigger (normal)" "$v_ontrigger") ;;
      2) v_onpump=$(buttonselector "Pump (normal)" $v_onpump) ;;
      3) v_onfl=$(buttonselector "Front Left (normal)" $v_onfl) ;;
      4) v_onbl=$(buttonselector "Back Left (normal)" $v_onbl) ;;
      5) v_onfr=$(buttonselector "Front Right (normal)" $v_onfr) ;;
      6) v_onbr=$(buttonselector "Back Right (normal)" $v_onbr) ;;
      7) v_onup=$(buttonselector "D-Pad Up (normal)" $v_onup) ;;
      8) v_ondown=$(buttonselector "D-Pad Down (normal)" $v_ondown) ;;
      9) v_onleft=$(buttonselector "D-Pad Left (normal)" $v_onleft) ;;
      10) v_onright=$(buttonselector "D-Pad Right (normal)" $v_onright) ;;
      *) return ;;
    esac
  done
}



function buttonsoffscreen() {
  local title
  local selection
  title="Button Mapping for Off-Screen Actions"
  while :; do
    selection=$(dialog --cancel-label " Back " --title "$title" --backtitle "$backtitle" --menu \
      "\nChoose which button you want to edit.\nThe current value is shown alongside the option." \
      20 70 10 \
        "1"  "Trigger ($v_offtrigger)" \
        "2"  "Pump ($v_offpump)" \
        "3"  "Front Left ($v_offfl)" \
        "4"  "Rear Left ($v_offbl)" \
        "5"  "Front Right ($v_offfr)" \
        "6"  "Rear Right ($v_offbr)" \
        "7"  "D-Pad Up ($v_offup)" \
        "8"  "D-Pad Down ($v_offdown)" \
        "9"  "D-Pad Left ($v_offleft)" \
       "10"  "D-Pad Right ($v_offright)" \
        3>&1 1>&2 2>&3 )
    case "$selection" in
      1) v_offtrigger=$(buttonselector "Trigger (off-screen)" "$v_offtrigger") ;;
      2) v_offpump=$(buttonselector "Pump (off-screen)" $v_offpump) ;;
      3) v_offfl=$(buttonselector "Front Left (off-screen)" $v_offfl) ;;
      4) v_offbl=$(buttonselector "Back Left (off-screen)" $v_offbl) ;;
      5) v_offfr=$(buttonselector "Front Right (off-screen)" $v_offfr) ;;
      6) v_offbr=$(buttonselector "Back Right (off-screen)" $v_offbr) ;;
      7) v_offup=$(buttonselector "D-Pad Up (off-screen)" $v_offup) ;;
      8) v_offdown=$(buttonselector "D-Pad Down (off-screen)" $v_offdown) ;;
      9) v_offleft=$(buttonselector "D-Pad Left (off-screen)" $v_offleft) ;;
      10) v_offright=$(buttonselector "D-Pad Right (off-screen)" $v_offright) ;;
      *) return ;;
    esac
  done
}



function buttononoffmenu(){
  local title
  local selection
  local yn
  title="Button Mapping On/Off-Screen Group Selection"
  selection=$(dialog --cancel-label " Quit without saving " --title "$title" --backtitle "$backtitle" --menu \
      "\nWhich button settings group would you like to view and edit?" \
      20 70 5 \
      "1"  "Normal button actions" \
      "2"  "Enable/Disable off-screen actions ($(onoffread $v_enableoffscreen))" \
      "3"  "Off-screen button actions" \
      "4"  "Transfer this file's settings to another config file" \
      "5"  "Save changes and exit" \
      3>&1 1>&2 2>&3 )
        case "$selection" in
          1) buttonsonscreen ;;
          2) v_enableoffscreen=$(onoffwrite $v_enableoffscreen) ;;
          3) buttonsoffscreen ;;
          4) settingstransfer "Button Map" ;;
          5) yn=$(areyousure "overwrite your $sourcename config file with the selections you have made?")
             if [ $yn == "0" ]; then
               savebuttons $sourcefile
               dialog --backtitle "$backtitle" --title "Save Complete" --msgbox "\nButton mapping changes have been saved for $sourcename." 12 78
               buttonmenuitem=9
             else
               buttonmenuitem=2
             fi ;;
          *) buttonmenuitem=9; return ;;
        esac
}



function buttonchoosefile(){
  local title
  local selection
  title="Button Config File Selection ($1)"
  choosefile "$title" "\nWhich config file would you like to view and edit?"
  sourcefile=$selfile
  sourcename=$selname
     if ! [ "$sourcename" = "" ] && [ $(filecheck $sourcefile) == "yes" ]; then
         buttonmenuitem=1
     else
         buttonmenuitem=9
     fi
}


function buttonmain(){
  buttonmenuitem=8
  while ! [[ $buttonmenuitem -eq 9 ]]; do
    case "$buttonmenuitem" in
#      0) buttonchoosegroup ;;
      0) buttonchoosefile ;;
      1) buttonprep
         buttonmenuitem=2 ;;
      2) buttononoffmenu;;
      8) captivedialog 50 15 50  "\nEditing the button mapping may lead to loss of functions in games if they have been pre-configured with the existing settings in mind.\n\nProceed only if you have made backups of your configs and you know what you are doing," "CAUTION!"
         case "$captivereturn" in
           0) ;;
           1|*) return ;;
         esac
         buttonmenuitem=0 ;;
     9|*) return ;;
    esac
  done
}






#############################
############  BACKUP #######
###########################



function restorebackup() {
  local title
  local selection
  local yn
  local originalfile
  local originalname
  title="Restore a Backup"
  choosefile "$title" "\nWhich $1 config file would you like to restore from backup?"
  originalfile=$selfile
  originalname=$selname
  if ! [ "$originalname" = "" ] && [ $(filecheck $originalfile.backup) == "yes" ]; then
      yn=$(areyousure "overwrite this file with the backup?\n\n$originalfile")
      if [ $yn = "0" ]; then
        cp -pf "$originalfile.backup" "$originalfile"
        dialog --title "$title" --msgbox "\nRestore of $originalfile from backup completed" 10 70
      fi
    fi
  backupmenuitem=0
}



function makebackup(){
  local title
  local selection
  local yn
  local originalfile
  local originalname
  title="Make a Backup"
  choosefile "$title" "\nWhich $1 config file would you like to backup?"
  originalfile=$selfile
  originalname=$selname
  if ! [ "$originalname" = "" ] && [ $(filecheck $originalfile) == "yes" ]; then
      yn=$(areyousure "make a backup of this file?\n If a backup with the extenstion \".backup\" already exists, it will be replaced.")
      if [ $yn = "0" ]; then
        cp -pf "$originalfile" "$originalfile.backup"
        dialog --title "$title" --msgbox "\nBackup of $originalfile completed" 10 70
      fi
    fi
  backupmenuitem=0
}





function backupmenu() {
  local title
  local selection
  title="Backup & Restore"
  selection=$(dialog --title "$title" --backtitle "$backtitle" --menu \
    "\nWhat do you want to do?" \
    20 70 2 \
      "1"  "Backup" \
      "2"  "Restore" \
      3>&1 1>&2 2>&3 )
    case "$selection" in
      1) makebackup ;;
      2) restorebackup ;;
      *) backupmenuitem=9
         return ;;
    esac
}




function backupmain(){
  backupmenuitem=0
  while ! [[ $backupmenuitem -eq 9 ]]; do
    case "$backupmenuitem" in
      0) backupmenu ;;
      9|*) return ;;
    esac
  done
}





##############################
############  MAIN   ########
############################



function frontmenu(){
  local title
  local selection
  while :; do
    title="Front Menu"
    selection=$(dialog --cancel-label " Exit " --title "$title" --backtitle "$backtitle" --menu \
        "\nWhat config elements would you like to view and edit?" \
        20 70 4 \
        "1"  "Recoil" \
        "2"  "Camera" \
        "3"  "Buttons" \
        "4"  "Backup & Restore" \
        3>&1 1>&2 2>&3 )
          case "$selection" in
            1) recoilmain ;;
            2) cameramain ;;
            3) buttonmain ;;
            4) backupmain ;;
            *) return ;;
          esac
  done
}



#############################
############  START  #######
###########################

prep
frontmenu
post
