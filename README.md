# I3 with manjaro and custom configs
## Install i3 with pacman
sudo pacman -S i3-wm i3lock i3status dunst compton hsetroot rxvt-unicode xsel rofi fonts-noto fonts-mplus xsettingsd lxappearance scrot viewnior

## copy dotnet files
cp .config/* ~/
cp .Xresources ~/
cp .xsettingsd ~/

## Install DejaVu Mono Sans for Powerline
git clone https://github.com/powerline/fonts.git
chmod a+x fonts/install.sh
./fonts/install.sh

