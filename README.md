# Dotfiles

Personal shell configuration for Debian/Ubuntu and Arch/CachyOS systems.

## Quick Install

```bash
bash <(curl -s https://raw.githubusercontent.com/ccarpo/dotfiles/master/install.sh)
```

Or clone and run locally:

```bash
git clone https://github.com/ccarpo/dotfiles.git ~/dotfiles
cd ~/dotfiles && bash install.sh
```

## What's Included

### Shell
- **Zsh** with **Oh-My-Zsh**
- **Powerlevel10k** theme with MesloLGS Nerd Fonts
- **Atuin** - shell history search & sync
- Custom aliases, keybindings, and dotfiles sync plugin

### Oh-My-Zsh Plugins
| Plugin | Description |
|--------|-------------|
| git | Git aliases and functions |
| aws | AWS CLI completions |
| docker / docker-compose | Docker aliases and completions |
| npm | npm completions |
| python | Python aliases |
| sudo | ESC ESC to prepend sudo |
| fzf | fzf integration |
| mise | Dev tool version manager |
| fast-syntax-highlighting | Real-time syntax highlighting |
| zsh-autosuggestions | Fish-like autosuggestions |
| autoupdate | Auto-update custom plugins |
| alias-tips | Reminds you of available aliases |
| fzf-tab | Replace default completion with fzf |
| dotfiles | Sync dotfiles helper |

### Modern CLI Tools

Installed by the script:

| Tool | Replaces | Description |
|------|----------|-------------|
| [bat](https://github.com/sharkdp/bat) | `cat` | Syntax highlighting, line numbers |
| [eza](https://github.com/eza-community/eza) | `ls` | Icons, git status, tree view |
| [delta](https://github.com/dandavison/delta) | `diff` | Beautiful git diffs, side-by-side |
| [fd](https://github.com/sharkdp/fd) | `find` | Simple, fast file finder |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | `grep` | Ultra-fast recursive search |
| [fzf](https://github.com/junegunn/fzf) | - | Fuzzy finder for everything |
| [zoxide](https://github.com/ajeetdsouza/zoxide) | `cd` | Smarter directory navigation |
| [atuin](https://github.com/atuinsh/atuin) | `ctrl-r` | Shell history search & sync |
| [procs](https://github.com/dalance/procs) | `ps` | Modern process viewer |
| [ncdu](https://dev.yorhel.nl/ncdu) | `du` | Interactive disk usage |
| [btop](https://github.com/aristocratos/btop) | `top/htop` | Resource monitor |
| [duf](https://github.com/muesli/duf) | `df` | Disk usage overview |
| [doggo](https://github.com/mr-karan/doggo) | `dig` | Modern DNS client |
| [gping](https://github.com/orf/gping) | `ping` | Ping with graph |
| [hyperfine](https://github.com/sharkdp/hyperfine) | `time` | Benchmarking tool |
| [tldr](https://github.com/tldr-pages/tldr) | `man` | Simplified man pages |
| [lazygit](https://github.com/jesseduffield/lazygit) | - | Terminal UI for git |
| [cht.sh](https://github.com/chubin/cheat.sh) | - | Cheat sheets in terminal |
| [plz-cli](https://github.com/m1guelpf/plz-cli) | - | GPT-powered command helper |

## File Structure

```
dotfiles/
  .zshrc                          # Main zsh configuration
  install.sh                       # Installer script
  config/
    atuin/config.toml              # Atuin configuration
    git/config                     # Git config template (with delta)
  oh-my-zsh-custom/
    custom/
      zsh_aliases.zsh              # Custom aliases
      zsh_binds.zsh                # Custom key bindings
    plugins/
      dotfiles/                    # Dotfiles sync plugin
```

## Post-Install

1. Restart your terminal or run `exec zsh`
2. Powerlevel10k config wizard runs automatically on first launch
3. Set your terminal font to **MesloLGS NF**
4. Optional: `atuin login` for shell history sync
5. Edit `~/.gitconfig` to set your name and email

## Credits

- [Oh-My-Zsh](https://ohmyz.sh/)
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
- [Atuin](https://github.com/atuinsh/atuin)
