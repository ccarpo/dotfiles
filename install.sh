#/bin/bash

# Check the Linux distribution
if [ -f /etc/debian_version ]; then
    # Debian or Ubuntu
    echo "Detected Debian or Ubuntu distribution."
    sudo apt update
    sudo apt install -y git zsh python3 python3-pip curl
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
git clone -b master https://github.com/ccarpo/dotfiles.git --recurse-submodules ~/dotfiles
cp -rf ~/dotfiles/.* ~
sed -i -e 's/<<replaceuser>>/'"$(whoami)"'/g' ~/.zshrc

#TODO ask if you want to install it for this user only then use ~/.local/share/fonts instead
echo "install p10k fonts"
sudo mkdir -p /usr/share/fonts/MesloLGS
sudo curl -LJ --output /usr/share/fonts/MesloLGS/MesloLGS\ NF\ Regular.ttf https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
sudo curl -LJ --output /usr/share/fonts/MesloLGS/MesloLGS\ NF\ Bold\ Italic.ttf https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
sudo curl -LJ --output /usr/share/fonts/MesloLGS/MesloLGS\ NF\ Italic.ttf https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
sudo curl -LJ --output /usr/share/fonts/MesloLGS/MesloLGS\ NF\ Bold.ttf https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf

echo "Install PowerLevel10k theme"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
zshrc_file=~/.zshrc
zsh_theme="ZSH_THEME=\"powerlevel10k/powerlevel10k\""

if grep -q "^ZSH_THEME=" "$zshrc_file"; then
  sed -i -e "s/^ZSH_THEME=.*/$zsh_theme/" "$zshrc_file"
else
  sed -i "1s|^|$zsh_theme\n|" "$zshrc_file"
fi

#FIX for zsh-alias
sed -i -e 's/egrep/grep -E/g' ~/.oh-my-zsh/custom/plugins/alias-tips/alias-tips.plugin.zsh
#TODO use preconfigured p10k rc file
echo "Install atuin"
bash <(curl https://raw.githubusercontent.com/atuinsh/atuin/main/install.sh)
