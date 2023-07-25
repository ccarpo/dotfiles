#/bin/bash

# Check the Linux distribution
if [ -f /etc/debian_version ]; then
    # Debian or Ubuntu
    echo "Detected Debian or Ubuntu distribution."
    sudo apt update
    sudo apt install -y git zsh python python-pip curl
elif [ -f /etc/redhat-release ]; then
    # Redhat based
    echo "Detected Redhat distribution."
    sudo yum install -y git zsh python python-pip curl
elif [ -f /etc/arch-release ] || [ -f /etc/manjaro-release ]; then
    # Manjaro or Arch Linux
    echo "Detected Manjaro or Arch Linux distribution."
    sudo pacman -Sy --noconfirm git zsh python python-pip curl
else
    echo "Unsupported distribution."
fi

# Check if ~/.oh-my-zsh folder exists and delete it if it does
echo "Try to install oh-my-zsh"
if [ -d ~/.oh-my-zsh ]; then
    echo "Deleting old ~/.oh-my-zsh folder."
    rm -rf ~/.oh-my-zsh
fi
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --skip-chsh --unattended

echo "Try install dotfiles repository"
if [ -d ~/dotfiles ]; then
    echo "Deleting old ~/dotfiles folder."
    rm -rf ~/dotfiles
fi
git clone -b p10k https://github.com/ccarpo/dotfiles.git --recurse-submodules ~/dotfiles
cp -rf ~/dotfiles/.* ~
sed -i -e 's/<<replaceuser>>/'"$(whoami)"'/g' ~/.zshrc

#TODO ask if you want to install it for this user only then use ~/.local/share/fonts instead
echo "install p10k fonts"
sudo curl -o /usr/share/fonts/MesloLGS\ NF\ Regular.ttf https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
sudo curl -o /usr/share/fonts/MesloLGS\ NF\ Bold\ Italic.ttf https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
sudo curl -o /usr/share/fonts/MesloLGS\ NF\ Italic.ttf https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
sudo curl -o /usr/share/fonts/MesloLGS\ NF\ Bold.ttf https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf

echo "Install PowerLevel10k theme"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
zshrc_file=~/.zshrc
zsh_theme="ZSH_THEME=\"powerlevel10k/powerlevel10k\""

if grep -q "^ZSH_THEME=" "$zshrc_file"; then
  sed -i -e "s/^ZSH_THEME=.*/$zsh_theme/" "$zshrc_file"
else
  echo "$zsh_theme" >> "$zshrc_file"
fi
#TODO use preconfigured p10k rc file
