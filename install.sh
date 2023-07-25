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

RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/subtlepseudonym/oh-my-zsh/feature/install-noninteractive/tools/install.sh)" --skip-chsh

echo "Clone dotfiles repository"
git clone -b p10k https://github.com/ccarpo/dotfiles.git --recurse-submodules ~/dotfiles
cp -rf ~/dotfiles/.* ~
sed -i -e 's/<<replaceuser>>/$(whoami)/g' .zshrc

#TODO ask if you wnat to install it for this user only then use ~/.local/share/fonts instead
echo "install p10k fonts"
sudo curl -o /usr/share/fonts/MesloLGS\ NF\ Regular.ttf https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
sudo curl -o /usr/share/fonts/MesloLGS\ NF\ Bold\ Italic.ttf https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
sudo curl -o /usr/share/fonts/MesloLGS\ NF\ Italic.ttf https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
sudo curl -o /usr/share/fonts/MesloLGS\ NF\ Bold.ttf https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf

echo "Install PowerLevel10k theme"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
sed -i 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc
#p10k configure
