# =============================================================================
# Custom ZSH Aliases
# =============================================================================

# -- MISC ---------------------------------------------------------------------
alias rmrf="rm -rf"
alias psef="ps -ef"
alias fuck='sudo $(fc -ln -1)'
alias grep='GREP_COLOR="1;37;41" LANG=C grep --color=auto'
alias grepi='grep -i'
alias wget="wget -c"
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias df='duf'
alias top='btop'
alias ping='gping'
alias dig='doggo'
alias help='tldr'
alias ps='procs'

# -- DIRECTORIES --------------------------------------------------------------
alias "cd.."="cd ../"
alias mkdir="mkdir -p"

if [[ "$(uname -s)" == "Linux" ]]; then
  alias myip="dig +short myip.opendns.com @resolver1.opendns.com"
  alias ips="ip -4 addr show | grep -oP '(?<=inet\s)\d+(\.\d+){3}'"
fi

# -- NETWORK ------------------------------------------------------------------
alias external_ip="curl -s icanhazip.com"

# -- EDITOR -------------------------------------------------------------------
alias e="$EDITOR"
alias se="sudo $EDITOR"

# -- KUBERNETES ---------------------------------------------------------------
alias kga='kubectl get all --all-namespaces'
alias kgi='kubectl get ingresses --all-namespaces'
alias kg='kubectl get'
alias ka='kubectl apply -f'
alias ke='kubectl edit'
alias kdesc='kubectl describe'
alias kdel='kubectl delete'

# -- DOCKER -------------------------------------------------------------------
alias dc='docker compose'
alias dps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias dlog='docker logs -f'

# -- GIT (shortcuts beyond the git plugin) ------------------------------------
alias lg='lazygit'
