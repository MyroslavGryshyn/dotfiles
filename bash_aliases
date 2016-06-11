alias l='ls -1F --group-directories-first --color=never'
alias ll='ls -AFlh --color=never'
alias la='ls -A --color=never'

alias pbcopy='xclip -sel clip'
alias pbpaste='xclip -sel clip -o'

alias gp='git push origin HEAD'
alias gs='git status -s'
alias gd='git diff -w'
alias gl="git log --abbrev-commit --decorate --format=format:'%C(bold blue)%h -%C(reset) %C(white)%s%C(reset) %C(bold blue)- %an%C(reset)%C(bold yellow)%d%C(reset)'"
alias glg="git log --abbrev-commit --decorate --format=format:'%C(bold blue)%h -%C(reset) %C(white)%s%C(reset) %C(bold blue)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all --graph"
alias gls="git log --pretty='format:%C(yellow)%h%C(reset) %C(blue)%ad %C(reset)%s %C(reset)%C(green)- %an,%C(reset) %C(bold blue)%ar' --date=short -S"
alias gll="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n''          %C(white)%s%C(reset) %C(bold blue)- %an%C(reset)' --all"
alias cl=clear
