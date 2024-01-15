# MISC
alias rmrf="rm -rf"
alias psef="ps -ef"
alias fuck='sudo $(fc -ln -1)'
alias grep='GREP_COLORS="1;37;41" LANG=C grep --color=auto'
alias grepi='grep -i'
alias wget="wget -c"
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# DIR
alias "cd.."="cd ../"
alias mkdir="mkdir -p"
#alias ..="cd .."
#alias ...="cd ../.."
if [[ "$(uname -s)" == "Linux" ]]; then
  # we're on linux
  #alias l-d="ls -lFad"
  #alias l="ls -laF"
  alias ll="ls -lFa | TERM=vt100 less"
##TODO add for windows
  alias myip="dig +short myip.opendns.com @resolver1.opendns.com"
  alias ips="ifconfig -a | perl -nle'/(\d+\.\d+\.\d+\.\d+)/ && print $1'"
fi

# NETWORK
alias external_ip="curl -s icanhazip.com"

# EDITOR
alias e="$EDITOR"
alias se="sudo $EDITOR"
#alias v="nvim"
#alias vimdiff="nvim -d -u ~/.vimrc"

# GIT
#alias g="git"
#alias ga="git add"
#alias gc="git commit -m"
#alias gs="git status"
#alias gd="git diff"
#alias gf="git fetch"
#alias gm="git merge"
#alias gr="git rebase"
#alias gp="git push"
#alias gu="git unstage"
#alias gg="git graph"
#alias ggg="git graphgpg"
#alias gco="git checkout"
#alias gcs="git commit -S -m"
#alias gpr="hub pull-request"

# KUBERNETES
alias kga='kubectl get all --all-namespaces'
alias kgi='kubectl get ingresses --all-namespaces'
alias kg='kubectl get'
alias ka='kubectl apply -f'
alias ke='kubectl edit'
alias kdesc='kubectl describe'
alias kdel='kubectl delete'

# DOCKER-COMPOSE
alias dc='docker-compose'
