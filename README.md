# Sinden_Lightgun_Config_Editor
A utility to edit the Sinden Lightgun .config files from EmulationStation with a controller or keyboard.

## How to install
If running from the Pi itself with a connected keyboard, press `F4` to exit EmulationStation and reach the command line.

Or you can connect to your Pi via SSH using a reliable utility such as PuTTY.

From the command line, type the following:
```
cd /home/pi/
wget https://github.com/Widge-5/Sinden_Lightgun_Config_Editor/raw/main/slgce_install.sh
chmod +x slgce_install.sh
sudo ./slgce_install.sh
```
This will download the script to your `/home/pi` folder and make it executable. The last line executes the script.

When you run the script you will be asked whether your Sinden start scripts are in the Sinden group (for BB9) or the Ports group (for BB8).

The script will then download the files needed and install them in their appropriate locations.

The install script will offer to delete itself then you will be prompted to restart EmulationStation

## What to expect
In the Sinden (or Ports) group, you will find a new script available called Sinden Lightgun Config Editor.  Executing this script will launch a menu system that will enable you to edit recoil settings and camera settings for each of your Sinden Lightgun configs using a keyboard or a control pad.  The menu also offers a facility to make backups of your configs and to restore those backups.

The utility is pre-configured with the addresses of the Lightgun config files as they are in barebones.  If your config files are in another location then you should edit the variables at the top of the script to reflect this.

The script can be found at `/home/pi/Lightgun/configedit/sindenconfigedit.sh`.

## Work in Progress
This tool is still a work-in-progress.  Everything contained within at this time is fully functional but there are future plans to include:
- Button map editing
- Transfering of recoil/camera/button settings between configs.
- (need to) add a reminder message to restart the guns for changes to take effect.
