#/bin/bash
#TODO check of distribution

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

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

git clone -b p10k https://github.com/ccarpo/dotfiles.git --recurse-submodules ~
sed -i -e 's/<<replaceuser>>/$(whoami)/g' .zshrc

#TODO ask if you wnat to install it for this user only then use ~/.local/share/fonts instead
sudo curl -o /usr/share/fonts/MesloLGS\ NF\ Regular.ttf https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
sudo curl -o /usr/share/fonts/MesloLGS\ NF\ Bold\ Italic.ttf https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
sudo curl -o /usr/share/fonts/MesloLGS\ NF\ Italic.ttf https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
sudo curl -o /usr/share/fonts/MesloLGS\ NF\ Bold.ttf https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
p10k configure
