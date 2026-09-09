#!/bin/bash
set -euo pipefail

# =============================================================================
# Dotfiles installer - Supports Debian/Ubuntu and Arch/CachyOS
# =============================================================================

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

info()  { echo -e "${GREEN}[INFO]${NC} $*"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $*"; }
error() { echo -e "${RED}[ERROR]${NC} $*"; exit 1; }

# -----------------------------------------------------------------------------
# Detect distro
# -----------------------------------------------------------------------------
detect_distro() {
    if [ -f /etc/debian_version ]; then
        DISTRO="debian"
        info "Detected Debian/Ubuntu"
    elif [ -f /etc/arch-release ]; then
        DISTRO="arch"
        info "Detected Arch/CachyOS/Manjaro"
    else
        error "Unsupported distribution. Only Debian/Ubuntu and Arch-based distros are supported."
    fi
}

# -----------------------------------------------------------------------------
# Install packages
# -----------------------------------------------------------------------------
install_packages() {
    info "Installing system packages..."

    if [ "$DISTRO" = "debian" ]; then
        sudo apt update
        sudo apt install -y \
            git zsh curl wget unzip fontconfig \
            python3 python3-pip \
            bat ncdu fzf ripgrep fd-find \
            btop duf gping

        # Debian names bat as batcat, fd as fdfind - create symlinks
        mkdir -p ~/.local/bin
        [ ! -L ~/.local/bin/bat ] && ln -sf /usr/bin/batcat ~/.local/bin/bat
        [ ! -L ~/.local/bin/fd ]  && ln -sf /usr/bin/fdfind ~/.local/bin/fd

        # Packages not in Debian repos - install via cargo/binary
        install_cargo_tools_debian

    elif [ "$DISTRO" = "arch" ]; then
        sudo pacman -Syu --noconfirm \
            git zsh curl wget unzip fontconfig \
            python python-pip \
            bat ncdu fzf ripgrep eza git-delta fd procs \
            btop duf gping dog hyperfine tldr lazygit \
            zoxide

        # cht.sh
        install_chtsh
    fi
}

install_cargo_tools_debian() {
    # Install tools not available in Debian repos via prebuilt binaries

    # eza (ls replacement)
    if ! command -v eza &>/dev/null; then
        info "Installing eza..."
        sudo mkdir -p /etc/apt/keyrings
        wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg 2>/dev/null || true
        echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list > /dev/null
        sudo chmod 644 /etc/apt/keyrings/gierens.gpg
        sudo apt update && sudo apt install -y eza
    fi

    # delta (git diff pager)
    if ! command -v delta &>/dev/null; then
        info "Installing delta..."
        DELTA_VERSION=$(curl -s https://api.github.com/repos/dandavison/delta/releases/latest | grep -oP '"tag_name": "\K[^"]+')
        DELTA_DEB="git-delta_${DELTA_VERSION}_amd64.deb"
        wget -q "https://github.com/dandavison/delta/releases/download/${DELTA_VERSION}/${DELTA_DEB}" -O "/tmp/${DELTA_DEB}"
        sudo dpkg -i "/tmp/${DELTA_DEB}" || sudo apt install -f -y
        rm -f "/tmp/${DELTA_DEB}"
    fi

    # procs (ps replacement)
    if ! command -v procs &>/dev/null; then
        info "Installing procs..."
        PROCS_VERSION=$(curl -s https://api.github.com/repos/dalance/procs/releases/latest | grep -oP '"tag_name": "\K[^"]+')
        wget -q "https://github.com/dalance/procs/releases/download/${PROCS_VERSION}/procs-${PROCS_VERSION}-x86_64-linux.zip" -O /tmp/procs.zip
        unzip -o /tmp/procs.zip -d /tmp/procs_bin
        sudo mv /tmp/procs_bin/procs /usr/local/bin/procs
        sudo chmod +x /usr/local/bin/procs
        rm -rf /tmp/procs.zip /tmp/procs_bin
    fi

    # zoxide (cd replacement) - may not be in older Debian repos
    if ! command -v zoxide &>/dev/null; then
        info "Installing zoxide..."
        curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
    fi

    # hyperfine (benchmarking)
    if ! command -v hyperfine &>/dev/null; then
        info "Installing hyperfine..."
        HYPERFINE_VERSION=$(curl -s https://api.github.com/repos/sharkdp/hyperfine/releases/latest | grep -oP '"tag_name": "\K[^"]+')
        HYPERFINE_DEB="hyperfine_${HYPERFINE_VERSION#v}_amd64.deb"
        wget -q "https://github.com/sharkdp/hyperfine/releases/download/${HYPERFINE_VERSION}/${HYPERFINE_DEB}" -O "/tmp/${HYPERFINE_DEB}"
        sudo dpkg -i "/tmp/${HYPERFINE_DEB}" || sudo apt install -f -y
        rm -f "/tmp/${HYPERFINE_DEB}"
    fi

    # tldr
    if ! command -v tldr &>/dev/null; then
        info "Installing tldr..."
        pip3 install --user tldr 2>/dev/null || pipx install tldr 2>/dev/null || true
    fi

    # lazygit
    if ! command -v lazygit &>/dev/null; then
        info "Installing lazygit..."
        LAZYGIT_VERSION=$(curl -s https://api.github.com/repos/jesseduffield/lazygit/releases/latest | grep -oP '"tag_name": "\K[^"]+' | sed 's/^v//')
        curl -Lo /tmp/lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
        tar xf /tmp/lazygit.tar.gz -C /tmp lazygit
        sudo install /tmp/lazygit /usr/local/bin
        rm -f /tmp/lazygit /tmp/lazygit.tar.gz
    fi

    # doggo (DNS client)
    if ! command -v doggo &>/dev/null; then
        info "Installing doggo..."
        DOGGO_VERSION=$(curl -s https://api.github.com/repos/mr-karan/doggo/releases/latest | grep -oP '"tag_name": "\K[^"]+' | sed 's/^v//')
        wget -q "https://github.com/mr-karan/doggo/releases/download/v${DOGGO_VERSION}/doggo_${DOGGO_VERSION}_linux_amd64.tar.gz" -O /tmp/doggo.tar.gz
        tar xf /tmp/doggo.tar.gz -C /tmp
        sudo mv /tmp/doggo /usr/local/bin/doggo
        sudo chmod +x /usr/local/bin/doggo
        rm -f /tmp/doggo.tar.gz
    fi

    # duf (disk usage)
    if ! command -v duf &>/dev/null; then
        info "Installing duf..."
        DUF_VERSION=$(curl -s https://api.github.com/repos/muesli/duf/releases/latest | grep -oP '"tag_name": "\K[^"]+' | sed 's/^v//')
        wget -q "https://github.com/muesli/duf/releases/download/v${DUF_VERSION}/duf_${DUF_VERSION}_linux_amd64.deb" -O /tmp/duf.deb
        sudo dpkg -i /tmp/duf.deb || sudo apt install -f -y
        rm -f /tmp/duf.deb
    fi

    # gping
    if ! command -v gping &>/dev/null; then
        info "Installing gping..."
        GPING_VERSION=$(curl -s https://api.github.com/repos/orf/gping/releases/latest | grep -oP '"tag_name": "\K[^"]+')
        GPING_DEB="gping_${GPING_VERSION#gping-}_amd64.deb"
        wget -q "https://github.com/orf/gping/releases/download/${GPING_VERSION}/${GPING_DEB}" -O "/tmp/gping.deb" || true
        sudo dpkg -i /tmp/gping.deb 2>/dev/null || sudo apt install -f -y || warn "Could not install gping"
        rm -f /tmp/gping.deb
    fi

    # cht.sh
    install_chtsh
}

install_chtsh() {
    if ! command -v cht.sh &>/dev/null; then
        info "Installing cht.sh..."
        sudo curl -s https://cht.sh/:cht.sh -o /usr/local/bin/cht.sh
        sudo chmod +x /usr/local/bin/cht.sh
    fi
}

# -----------------------------------------------------------------------------
# Install Nerd Fonts (MesloLGS NF for Powerlevel10k)
# -----------------------------------------------------------------------------
install_fonts() {
    info "Installing Nerd Fonts (MesloLGS NF)..."
    local font_dir="$HOME/.local/share/fonts/MesloLGS"
    mkdir -p "$font_dir"

    local base_url="https://github.com/romkatv/powerlevel10k-media/raw/master"
    local fonts=(
        "MesloLGS NF Regular.ttf"
        "MesloLGS NF Bold.ttf"
        "MesloLGS NF Italic.ttf"
        "MesloLGS NF Bold Italic.ttf"
    )

    for font in "${fonts[@]}"; do
        local encoded="${font// /%20}"
        if [ ! -f "$font_dir/$font" ]; then
            curl -sSL "${base_url}/${encoded}" -o "$font_dir/$font"
        fi
    done

    fc-cache -f "$font_dir"
    info "Fonts installed to $font_dir"
}

# -----------------------------------------------------------------------------
# Install Oh-My-Zsh
# -----------------------------------------------------------------------------
install_ohmyzsh() {
    info "Installing Oh-My-Zsh..."
    if [ -d "$HOME/.oh-my-zsh" ]; then
        warn "Oh-My-Zsh already installed, skipping..."
    else
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi
}

# -----------------------------------------------------------------------------
# Install Oh-My-Zsh custom plugins
# -----------------------------------------------------------------------------
install_omz_plugins() {
    local custom_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

    info "Installing Oh-My-Zsh plugins..."

    # fast-syntax-highlighting
    if [ ! -d "$custom_dir/plugins/fast-syntax-highlighting" ]; then
        git clone --depth=1 https://github.com/zdharma-continuum/fast-syntax-highlighting.git \
            "$custom_dir/plugins/fast-syntax-highlighting"
    fi

    # zsh-autosuggestions
    if [ ! -d "$custom_dir/plugins/zsh-autosuggestions" ]; then
        git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git \
            "$custom_dir/plugins/zsh-autosuggestions"
    fi

    # autoupdate
    if [ ! -d "$custom_dir/plugins/autoupdate" ]; then
        git clone --depth=1 https://github.com/TamCore/autoupdate-oh-my-zsh-plugins.git \
            "$custom_dir/plugins/autoupdate"
    fi

    # alias-tips
    if [ ! -d "$custom_dir/plugins/alias-tips" ]; then
        git clone --depth=1 https://github.com/djui/alias-tips.git \
            "$custom_dir/plugins/alias-tips"
    fi
    # Fix deprecated egrep in alias-tips
    sed -i 's/egrep/grep -E/g' "$custom_dir/plugins/alias-tips/alias-tips.plugin.zsh" 2>/dev/null || true

    # fzf-tab (better fzf completion)
    if [ ! -d "$custom_dir/plugins/fzf-tab" ]; then
        git clone --depth=1 https://github.com/Aloxaf/fzf-tab.git \
            "$custom_dir/plugins/fzf-tab"
    fi
}

# -----------------------------------------------------------------------------
# Install Powerlevel10k
# -----------------------------------------------------------------------------
install_p10k() {
    local custom_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

    info "Installing Powerlevel10k..."
    if [ ! -d "$custom_dir/themes/powerlevel10k" ]; then
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
            "$custom_dir/themes/powerlevel10k"
    else
        warn "Powerlevel10k already installed, updating..."
        git -C "$custom_dir/themes/powerlevel10k" pull --ff-only 2>/dev/null || true
    fi
}

# -----------------------------------------------------------------------------
# Install Atuin (shell history)
# -----------------------------------------------------------------------------
install_atuin() {
    if ! command -v atuin &>/dev/null; then
        info "Installing Atuin..."
        bash <(curl -sSL https://raw.githubusercontent.com/atuinsh/atuin/main/install.sh)
    else
        info "Atuin already installed"
    fi
}

# -----------------------------------------------------------------------------
# Install plz-cli
# -----------------------------------------------------------------------------
install_plz() {
    info "Setting up plz-cli (GPT-powered command helper)..."
    # plz-cli is sourced via eval in .zshrc, no separate install needed
    # It auto-installs on first shell load via: eval "$(curl -sL plztell.me/setup)"
}

# -----------------------------------------------------------------------------
# Create symlinks
# -----------------------------------------------------------------------------
create_symlinks() {
    info "Creating symlinks..."

    # .zshrc
    ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
    info "  ~/.zshrc -> $DOTFILES_DIR/.zshrc"

    # Atuin config
    mkdir -p "$HOME/.config/atuin"
    ln -sf "$DOTFILES_DIR/config/atuin/config.toml" "$HOME/.config/atuin/config.toml"
    info "  ~/.config/atuin/config.toml -> $DOTFILES_DIR/config/atuin/config.toml"

    # Git config (only if no existing .gitconfig with user-specific settings)
    if [ ! -f "$HOME/.gitconfig" ]; then
        ln -sf "$DOTFILES_DIR/config/git/config" "$HOME/.gitconfig"
        info "  ~/.gitconfig -> $DOTFILES_DIR/config/git/config"
    else
        warn "  ~/.gitconfig exists, skipping (merge manually from $DOTFILES_DIR/config/git/config)"
    fi

    # Custom zsh files -> oh-my-zsh custom dir
    local custom_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

    ln -sf "$DOTFILES_DIR/oh-my-zsh-custom/custom/zsh_aliases.zsh" "$custom_dir/zsh_aliases.zsh"
    info "  $custom_dir/zsh_aliases.zsh -> $DOTFILES_DIR/oh-my-zsh-custom/custom/zsh_aliases.zsh"

    ln -sf "$DOTFILES_DIR/oh-my-zsh-custom/custom/zsh_binds.zsh" "$custom_dir/zsh_binds.zsh"
    info "  $custom_dir/zsh_binds.zsh -> $DOTFILES_DIR/oh-my-zsh-custom/custom/zsh_binds.zsh"

    # Dotfiles plugin
    mkdir -p "$custom_dir/plugins/dotfiles"
    ln -sf "$DOTFILES_DIR/oh-my-zsh-custom/plugins/dotfiles/dotfiles.plugin.zsh" \
        "$custom_dir/plugins/dotfiles/dotfiles.plugin.zsh"
    info "  $custom_dir/plugins/dotfiles/ -> $DOTFILES_DIR/oh-my-zsh-custom/plugins/dotfiles/"
}

# -----------------------------------------------------------------------------
# Set zsh as default shell
# -----------------------------------------------------------------------------
set_default_shell() {
    if [ "$SHELL" != "$(which zsh)" ]; then
        info "Setting zsh as default shell..."
        chsh -s "$(which zsh)" || warn "Could not change default shell. Run: chsh -s \$(which zsh)"
    else
        info "zsh is already the default shell"
    fi
}

# -----------------------------------------------------------------------------
# Main
# -----------------------------------------------------------------------------
main() {
    echo ""
    echo "============================================="
    echo "  Dotfiles Installer"
    echo "  Debian/Ubuntu & Arch/CachyOS"
    echo "============================================="
    echo ""

    detect_distro
    install_packages
    install_fonts
    install_ohmyzsh
    install_omz_plugins
    install_p10k
    install_atuin
    install_plz
    create_symlinks
    set_default_shell

    echo ""
    info "Installation complete!"
    info ""
    info "Next steps:"
    info "  1. Restart your terminal or run: exec zsh"
    info "  2. Powerlevel10k configuration wizard will run automatically"
    info "  3. Make sure your terminal font is set to 'MesloLGS NF'"
    info "  4. Configure atuin with: atuin login (optional, for sync)"
    echo ""
}

main "$@"
