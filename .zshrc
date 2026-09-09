# =============================================================================
# Powerlevel10k instant prompt (must stay near the top)
# =============================================================================
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# =============================================================================
# Oh-My-Zsh configuration
# =============================================================================
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="powerlevel10k/powerlevel10k"

# Plugins
# Standard plugins: ~/.oh-my-zsh/plugins/
# Custom plugins:   ~/.oh-my-zsh/custom/plugins/
plugins=(
  git
  aws
  docker
  docker-compose
  npm
  python
  sudo
  fzf
  mise
  dotfiles
  fast-syntax-highlighting
  zsh-autosuggestions
  autoupdate
  alias-tips
  fzf-tab
)

source $ZSH/oh-my-zsh.sh

# =============================================================================
# PATH
# =============================================================================
export PATH="$HOME/.local/bin:$HOME/.atuin/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PATH"

# =============================================================================
# Environment
# =============================================================================
export EDITOR='vim'
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# History settings
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY

# =============================================================================
# Modern CLI tool integrations
# =============================================================================

# Atuin - shell history search (replaces ctrl-r)
if command -v atuin &>/dev/null; then
  eval "$(atuin init zsh)"
fi

# Zoxide - smarter cd
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
fi

# fzf - fuzzy finder
if command -v fzf &>/dev/null; then
  # Use fd for fzf if available (respects .gitignore)
  if command -v fd &>/dev/null; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
  fi
  export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --info=inline'
fi

# bat - cat replacement with syntax highlighting
if command -v bat &>/dev/null; then
  export BAT_THEME="Dracula"
  alias cat='bat --paging=never'
  alias catp='bat'
fi

# eza - modern ls replacement
if command -v eza &>/dev/null; then
  alias ls='eza --icons --group-directories-first'
  alias ll='eza -la --icons --group-directories-first --git'
  alias lt='eza -la --icons --group-directories-first --tree --level=2'
  alias la='eza -a --icons --group-directories-first'
fi

# mise (dev tool version manager)
if command -v mise &>/dev/null; then
  eval "$(mise activate zsh)"
fi

# plz-cli (GPT-powered command helper)
# Uncomment the following line to enable plz-cli:
# eval "$(curl -sL plztell.me/setup)"

# =============================================================================
# Powerlevel10k config
# =============================================================================
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
