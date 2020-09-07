#!/bin/bash
echo
echo "Please Double Check The Script For Accuracy"
sleep 2
nano e14.sh
echo
echo "Welcome to the Element14 Installation & Setup Script (For Raspberry Pi 3 b+)"
echo
sleep 2
echo "Let's do some updates..."
sudo apt-get update && sudo apt update && sudo apt upgrade && sudo apt dist-upgrade && sudo apt full-upgrade && sudo apt clean
echo
echo "Now Let's begin..."
echo
read -r -p "Press the [ENTER] key to continue ..."
echo
echo "First Agenda: Set Hardware Tweaks like USB current & ZRAM SWAP ..."
sleep 3
echo "Setting USB bus current to 1.2A ..."
echo
printf '%s\n' '/#arm_freq=800/a' '' '# uncomment to increase USB bus current to 1.2A (1200mA) (default is 600mA)' 'max_usb_current=1' . wq | sudo ed -s /boot/config.txt
echo
echo "Please verify the modifications were issued correctly and make additional adjustments as needed."
echo "For example: overclocking settings ..."
echo
read -r -p "Press the [ENTER] key when ready ..."
sudo nano /boot/config.txt
echo
echo "Let's setup ZRAM ..."
sleep 3
echo
echo "Installing Debian's ZRAM..."
sudo apt install zram-tools
echo
echo "Please verify the settings were issued correctly and make additional adjustments as needed ..."
echo
read -r -p "Press the [ENTER] key when ready ..."
sudo nano /etc/default/zramswap
echo
echo "Thank You"
echo 
echo "Setting up novaspirit's ZRAM as a contingency plan ..."
echo
sudo wget -O /usr/bin/zram.sh https://raw.githubusercontent.com/novaspirit/rpi_zram/master/zram.sh
sudo chmod +x /usr/bin/zram.sh
printf '%s\n' '/# By default this script does nothing./a' '' '# Uncomment to enable novaspirit ZRAM from script' '#/usr/bin/zram.sh &' . wq | sudo ed -s /etc/rc.local
echo
echo "Double Check and verify novaspirit's ZRAM option was added ..."
echo
read -r -p "Press the [ENTER] key when ready ..."
sudo nano /etc/rc.local
echo
echo "Thank You"
echo
read -r -p "Press the [ENTER] key when ready to continue ..."
echo
echo "Next Agenda: configuring locale, system, and network settings"
echo "Please set and double check all corresponding settings..."
echo
read -r -p "Press the [ENTER] key when ready ..."
echo
sudo raspi-config
echo
echo "Please Double Check & Make Certain Your locale settings"
echo "are Set and Correct..."
echo
read -r -p "Press the [ENTER] key when ready ..."
while true; do
        echo
        echo "Please answer Yes or No"
        echo
    locale
    echo
        read -r -p "Are your locale settings correct? " answer
        yn="$(echo "$answer" | tr A-Z a-z)"
        case $yn in
                yes) echo "Good, continuing on ..."; break;;
                no) read -r -p "Please try adjusting again, press [ENTER] key when ready ..."; sudo raspi-config;;
                * ) echo "Please answer yes or no. ";;
        esac
done
echo
echo "Thank You"
echo
sleep 1
echo "Next Agenda: Download and Install element14's official Pi Desktop Software"
echo
read -r -p "Press the [ENTER] Key to continue ..."
echo
echo "First to donwnload ..."
echo
sleep 2
wget -O "$HOME/Downloads/pidesktop-base-1.1.0.zip" "https://github.com/pi-desktop/deb-make/releases/download/v1.1.0/pidesktop-base-1.1.0.zip"
#wget -nc -P "$HOME/Downloads/" "https://github.com/pi-desktop/deb-make/releases/download/v1.1.0/pidesktop-base-1.1.0.zip"
echo "pidesktop-base-1.1.0.zip was saved in $HOME/Downloads"
echo
sleep 2
echo "Now to extract..."
echo
sleep 2
unzip "$HOME/Downloads/pidesktop-base-1.1.0.zip" -d "$HOME/Downloads/"
#(cd "$HOME/Downloads/" && unzip "pidesktop-base-1.1.0.zip")
echo
sleep 2
echo "Now to install..."
echo
while true; do
    echo
    echo "Please answer Yes or No"
    echo
        read -r -p "Do you wish to install the pidesktop-base-1.1.0.deb package? " answer
        yn="$(echo "$answer" | tr A-Z a-z)"
        case $yn in
                yes) sudo dpkg -i "$HOME/Downloads/pidesktop-base-1.1.0.deb"; break;;
                no) read -r -p "Very Well... Press the [ENTER] Key to continue ..."; break;;
                * ) echo "Please answer yes or no. ";;
        esac
done
echo
echo "Next Agenda: Setting up and Configuring a New User"
echo
read -r -p "Press the [ENTER] key to continue ..."
echo
echo "First to set universal environments ..."
echo
sleep 3
echo "Making universal .local folders for users ..."
echo
# Make universal .local folders for users
sudo mkdir /etc/skel/.local
sudo mkdir /etc/skel/.local/bin
sudo mkdir /etc/skel/.local/src
sleep 2
echo "Setting universal paths for .local folders for users ..."
echo 
# Put the following into /etc/skel/.profile
printf '%s\n' "/# set PATH so it includes user's private bin if it exists/i" "# set PATH so it includes user's hidden private bin if it exists" 'if [ -d "$HOME/.local/bin" ] ; then'  '    PATH="$HOME/.local/bin:$PATH"'  "fi"  '' . wq | sudo ed -s /etc/skel/.profile
echo
sleep 2
echo "Please Confirm the Modifications ..."
echo
read -r -p "Press the [ENTER] key to continue ..."
echo
sudo nano /etc/skel/.profile
echo
echo "Thank You"
echo
sleep 2
echo "Setting Path Environment for /etc/skel/.zshenv ..."
echo
# Put the following into the /etc/skel/.zshenv
sudo echo 'typeset -U path' | sudo tee -a /etc/skel/.zshenv
sudo echo 'path=(~/.local/bin $path[@])' | sudo tee -a /etc/skel/.zshenv
echo
sleep 3
echo
echo "Please Confirm the Modifications ..."
echo
sleep 3
sudo nano /etc/skel/.zshenv
#nano
echo
echo "Thank You!"
echo
sleep 2
echo
echo "Next to add a new user..."
echo
sleep 3
sudo adduser rkm
echo
sleep 2
echo
echo "Next to grant new user escalated privileges..."
echo
sleep 3
printf '%s\n' '/root[[:space:]]\+ALL=(ALL:ALL) ALL/a' 'rkm     ALL=(ALL) NOPASSWD: ALL' . wq | sudo ed -s /etc/sudoers
sleep 3
echo "Double check modifications..."
sudo visudo
echo
sleep 3
echo "Now to add the new user to groups..."
echo
sudo adduser rkm sudo
sudo usermod -a -G adm,dialout,cdrom,sudo,audio,video,plugdev,games,users,input,netdev,bluetooth,gpio,i2c,spi rkm
echo
sleep 2
echo "Please confirm that the user has been added to all the approprite groups..."
echo
sudo groups rkm
echo
read -r -p "Press the [ENTER] key when ready to continue ..."
echo
echo "Now let's give the new user GUI escalated privileges..."
echo
sudo apt install gksu-polkit libpolkit-agent-1-0 libgksu-polkit0 gir1.2-polkit-1.0 libpolkit-backend-1-0 libpolkit-gobject-1-0
printf '%s\n' '/AdminIdentities/s/;unix-user:0/;unix-user:rkm&/' wq | sudo ed -s /etc/polkit-1/localauthority.conf.d/50-localauthority.conf
printf '%s\n' '/AdminIdentities/s/;unix-user:0/;unix-user:rkm&/' wq | sudo ed -s /etc/polkit-1/localauthority.conf.d/60-desktop-policy.conf
sleep 2
echo
echo "Now please verify the entries were added to 50-localauthority.conf properly ..."
echo
read -r -p "Press the [ENTER] key when ready ..."
sudo nano /etc/polkit-1/localauthority.conf.d/50-localauthority.conf
echo
echo "Now please verify the entries were added to 6-desktop-policy.conf properly ..."
echo
read -r -p "Press the [ENTER] key when ready ..."
sudo nano /etc/polkit-1/localauthority.conf.d/60-desktop-policy.conf
echo
sleep 2
echo "Thank You"
echo
echo "Let's do some updates..."
sudo apt-get update && sudo apt update && sudo apt upgrade && sudo apt dist-upgrade && sudo apt full-upgrade && sudo apt clean  && sudo rpi-update
echo
sleep 3
echo "Next Section: Install and Setup ZSH"
echo
read -r -p "Press the [ENTER] key to continue ..."
echo
echo Installing ZSH ...
echo
sudo apt install git zsh zsh-doc screenfetch neofetch inxi
echo
echo "Changing default Shell to ZSH ..."
echo
chsh -s $(which zsh) #Makes zsh default shell
echo
echo "Installing Oh-My-ZSH ..."
echo "Just exit out of zsh once installed to return to the installation and setup script."
echo
read -r -p "Press the [ENTER] key when ready ..."
echo
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
echo "Changing ZSH theme ..."
echo
printf '%s\n' '?^ZSH_THEME?s/robbyrussell/gnzh/' wq | ed -s "$HOME/.zshrc"
echo "Please confirm adjustments have been made ..."
echo
read -r -p "Press the [ENTER] key when ready ..."
nano "$HOME/.zshrc"
echo
sleep 3
echo "Next Agenda: Installing Software"
echo
sleep 3
echo "Let's do some updates first..."
sudo apt-get update && sudo apt update && sudo apt upgrade && sudo apt dist-upgrade && sudo apt full-upgrade && sudo apt clean && sudo rpi-update
echo
sleep 3
echo "Now we can install the unofficial element14 Pi Desktop Software if desired"
echo
sleep 3
echo "First to donwnload... "
echo
sleep 2
wget -N -P "$HOME/Downloads/" "https://github.com/hoopsurfer/pidesktop/releases/download/v1.1.7/pidesktop-base.deb"
echo "pidesktop-base.deb was saved in $HOME/Downloads"
echo
sleep 2
echo "Now to install..."
echo
while true; do
    echo
    echo "Please answer Yes or No"
    echo
        read -r -p "Do you wish to install the pidesktop-base.deb package? " answer
        yn="$(echo "$answer" | tr A-Z a-z)"
        case $yn in
                yes) sudo dpkg -i "$HOME/Downloads/pidesktop-base.deb"; break;;
                no) read -r -p "Very Well... Press the [ENTER] Key to continue ..."; break;;
                * ) echo "Please answer yes or no. ";;
        esac
done
echo
sleep 3
echo
echo "Let's install RetroPie..."
echo
sudo apt install git lsb-release
cd "/usr/local/src"
sudo git clone --depth=1 https://github.com/RetroPie/RetroPie-Setup.git
cd "/usr/local/src/RetroPie-Setup"
sudo chmod +x retropie_setup.sh
sudo ./retropie_setup.sh
echo
echo "Be sure to coppy all your ROMs over to $HOME/RetroPie/roms folder..."
echo "Use 'emulationstation' to access and setup RetroPie..."
echo "Don't forget to setup controllers properly, bluetooth, and splash screen settings."
echo "..."
echo
sleep 4
echo
#echo "Let's uninstall LXDE and install just OpenBox ..."
echo "Let's install compiling and building tools ..."
echo
sudo apt install build-essential libcurses-perl libncurses-dev make automake
sudo apt install autoconf
sudo apt install binutils-for-build
sudo apt install git
sudo apt install gcc
sudo apt install gcc-8
sudo apt install clang
sudo apt install clang-7
sudo apt install clang-tools-7
sudo apt install python
sudo apt install python3
sudo apt install meson
sudo apt install ninja-build
sudo apt install libxext-dev libxcb1-dev libxcb-damage0-dev libxcb-xfixes0-dev libxcb-shape0-dev libxcb-render-util0-dev libxcb-render0-dev libxcb-randr0-dev libxcb-composite0-dev libxcb-image0-dev libxcb-present-dev libxcb-xinerama0-dev libpixman-1-dev libdbus-1-dev libconfig-dev libgl1-mesa-dev  libpcre2-dev  libevdev-dev uthash-dev libev-dev libx11-xcb-dev
sudo apt install asciidoc
echo
sleep 3
echo
echo "Let's install and confirm the GUI setup ..."
echo
echo "Let's do some updates first..."
sudo apt update && sudo apt upgrade && sudo apt dist-upgrade && sudo apt full-upgrade && sudo apt clean
echo
echo "Now Let's begin ..."
echo
sleep 2
echo "First we need to confirm xserver is installed ..."
echo
sleep 2
sudo apt install --no-install-recommends xserver-xorg
sudo apt install --no-install-recommends xinit
sleep 2
echo
#echo "Now we can uninstall LXDE ... "
#echo
#sleep 2
#sudo apt purge lxde*
#sudo apt install task-xfce-desktop xfce4 xfce4-terminal xfce4-goodies xfce4-screenshooter #Installs XFCE
#sleep 2
#echo 
# Install OpenBox Window Manager #
#echo "Now to install OpenBox ..."
#echo
#sleep 2
#sudo apt install openbox tint2
#sudo apt install tint2
# Install bspwm Window Manager
sudo apt install bspwm sxhkd
sudo apt install dunst rofi
echo
echo "Now to confirm lightdm is installed ..."
echo
sleep 2
sudo apt install lightdm
#echo "Now to set the default Window Manger ..."
#sudo update-alternatives --config x-session-manager
#echo
#sleep 3
echo
echo "Let's install additional software..."
echo
sleep 2
echo "Let's download some packages..."
echo
wget -N -P "$HOME/Downloads/" "http://packages.linuxmint.com/pool/main/m/mint-x-icons/mint-x-icons_1.5.5_all.deb"
wget -N -P "$HOME/Downloads/" "http://packages.linuxmint.com/pool/main/m/mint-y-icons/mint-y-icons_1.4.3_all.deb"
wget -N -P "$HOME/Downloads/" "http://packages.linuxmint.com/pool/main/m/mint-elementary-icons/mint-elementary-icons_1.0.0_all.deb"
wget -N -P "$HOME/Downloads/" "http://packages.linuxmint.com/pool/main/m/mint-themes/mint-themes_1.8.6_all.deb"
wget -N -P "$HOME/Downloads/" "http://packages.linuxmint.com/pool/main/m/mintinstall-icons/mintinstall-icons_1.0.7_all.deb"
echo
echo "Now to install packages..."
sudo dpkg -i "$HOME/Downloads/mint-x-icons_1.5.5_all.deb"
sudo dpkg -i "$HOME/Downloads/mint-y-icons_1.4.3_all.deb"
sudo dpkg -i "$HOME/Downloads/mint-elementary-icons_1.0.0_all.deb"
sudo dpkg -i "$HOME/Downloads/mint-themes_1.8.6_all.deb"
sudo dpkg -i "$HOME/Downloads/mintinstall-icons_1.0.7_all.deb"
echo
sleep 3
echo "installing term tools..."
echo
sudo apt install rxvt-unicode
sudo apt install less htop
sudo apt install mc ranger scrot newsboat dosbox irssi irssi-scripts
echo
echo "installing gui stuff..."
echo
sudo apt install nitrogen trayer pnmixer mousepad zathura
sudo apt install thunar xfce4-screenshooter xfce4-panel xfce4-notifyd gnome-system-tools
echo
echo "installing fun ..."
echo
sudo apt install lolcat cowsay fortune fortunes figlet toilet sl cmatrix oneko espeak conky libaa-bin bb dosbox
echo
echo "installing system tools..."
echo
sudo apt install gparted filezilla transmission gdebi catfish mugshot xarchiver
sudo apt install apparmor apparmor-utils apparmor-notify apparmor-easyprof apparmor-profiles apparmor-profiles-extra
echo
echo "installing fileformat tools..."
echo
sudo apt install dos2unix
sudo apt install ntfs-3g exfat-fuse eject hfsplus hfsutils hfsprogs rpi-imager
echo
echo "installing multimedia software..."
echo
sudo apt install mpv vlc ffmpeg
sudo apt install feh inkscape gimp gimp-help-en gimp-data-extras gimp-python
sudo apt install pinta
sudo apt install pianobar mpd ncmpcpp cmus pulseaudio pithos audacity audacious
echo
echo "installing communications software..."
echo
sudo apt install bluez bluez-firmware bluez-cups bluetooth blueman pi-bluetooth network-manager-gnome nm-tray
sudo apt install geary neomutt telnet
sudo apt install midori lynx links2 w3m
sudo apt install hexchat hexchat-plugins
echo
echo "installing Official Raspberry Pi Stuff..."
echo
sudo apt install rpi-chromium-mods
sudo apt install pix-icons
#sudo apt install menulibre
sudo apt install rc-gui
sudo apt install raspi-config
# sudo apt install rpd-icons raspberrypi-artwork rpd-plym-splash rpd-wallpaper
# sudo apt install raspberrypi-ui-mods pi-greeter pishutdown pipanel raspberrypi-net-mods raspberrypi-sys-mods
sudo apt install xscreensaver xscreensaver-data xscreensaver-gl-extra xscreensaver-data-extra rss-glx
sudo apt install xtrlock
echo
echo "install Office Suite..."
echo
sudo apt install libreoffice
echo
echo "install Development tools..."
echo
sudo apt install geany geany-plugins
sudo apt install nodered bluej greenfoot
sudo apt install wolfram-engine wolframscript fonts-mathematica libmath-quaternion-perl
#sudo apt install python3-thonny-pi #Depends: thonny but it is not going to be installed
sudo apt install scratch scratch2
sudo apt install sonic-pi sonic-pi-samples 
sudo apt install sense-hat python3-pisense python3-sense-emu python3-sense-hat
# pip install seashells 
echo
sleep 3
echo
# Fix WiFi & Bluetooth
#sudo nano /etc/NetworkManager/NetworkManager.conf 
#sudo iwlist wlan0 scan
#sudo nano /etc/wpa_supplicant/wpa_supplicant.conf
# Fix Wireless Mouse
# Copy Cow Files Over try to use pkexec thunar
# Copy scripts over
# Copy HexChat Configs over
echo
screenfetch
echo
lsb_release -d -c
echo
uname -a
uptime
echo
inxi -Fxxxpwrz
echo
lsblk
echo
