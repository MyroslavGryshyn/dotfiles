source $HOME/antigen/antigen.zsh

# Load oh-my-zsh's library
antigen use oh-my-zsh

# Bundles from the default repo
antigen bundle pip
antigen bundle pyenv
antigen bundle python
antigen bundle sudo
antigen bundle command-not-found
antigen bundle heroku
antigen bundle colored-man-pages
antigen bundle colorize
antigen bundle compleat
antigen bundle safe-paste
antigen bundle tmux
antigen bundle z
antigen bundle vagrant
antigen bundle django

# Bundles from third-party repos
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle djui/alias-tips
antigen bundle zsh-users/zsh-autosuggestions
antigen-bundle Tarrasch/zsh-autoenv
# Load the theme
antigen theme robbyrussell

antigen apply

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# User configuration

export PATH="$HOME/.pyenv/plugins/pyenv-virtualenv/shims:$HOME/.pyenv/libexec:$HOME/.pyenv/plugins/python-build/bin:$HOME/.pyenv/plugins/pyenv-virtualenv/bin:$HOME/.pyenv/plugins/pyenv-update/bin:$HOME/.pyenv/plugins/pyenv-installer/bin:$HOME/.pyenv/plugins/pyenv-doctor/bin:$HOME/.pyenv/shims:$HOME/.pyenv/bin:$HOME/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:$HOME/.fzf/bin:$HOME/bin"
# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
export EDITOR='nvim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# don't share history across different terminal sessions
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000000
SAVEHIST=10000000
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt NO_SHARE_HISTORY          # Don't share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.
setopt HIST_BEEP                 # Beep when accessing nonexistent history.
setopt HISTIGNORESPACE

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
alias l='ls -1F --group-directories-first --color=never'
alias ll='ls -AFlh --color=never'
alias la='ls -A --color=never'

alias pbcopy='xclip -sel clip'
alias pbpaste='xclip -sel clip -o'

alias gp='git push origin HEAD'
alias gs='git status -sb'
alias gd='git diff -w'
alias gdc='git diff --cached -w'
alias gl="git log --abbrev-commit --decorate --format=format:'%C(bold blue)%h -%C(reset) %C(white)%s%C(reset) %C(bold blue)- %an%C(reset)%C(bold yellow)%d%C(reset)'"
alias glg="git log --abbrev-commit --decorate --format=format:'%C(bold blue)%h -%C(reset) %C(white)%s%C(reset) %C(bold blue)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all --graph"
alias gls="git log --pretty='format:%C(yellow)%h%C(reset) %C(blue)%ad %C(reset)%s %C(reset)%C(green)- %an,%C(reset) %C(bold blue)%ar' --date=short -S"
alias gll="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n''          %C(white)%s%C(reset) %C(bold blue)- %an%C(reset)' --all"
alias rm=trash
alias tmux="TERM=xterm-256color tmux"
alias vim="nvim"
alias pty="prettyjson"

# Base16 Shell
BASE16_SHELL="$HOME/.config/base16-shell/scripts/base16-eighties.sh"
[[ -s $BASE16_SHELL ]] && source $BASE16_SHELL

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f ~/.key-binding.zsh ] && source ~/.key-binding.zsh

export FZF_DEFAULT_COMMAND='ag -g "" --hidden'
export FZF_DEFAULT_OPTS='--color=dark,bg+:18'
export FZF_TMUX=0


Z_SCRIPT="$HOME/.rupa_z/z.sh"
[[ -s $Z_SCRIPT ]] && source $Z_SCRIPT

unalias z
z() {
  if [[ -z "$*" ]]; then
    cd "$(_z -l 2>&1 | fzf +s --tac | sed 's/^[0-9,.]* *//')"
  else
    _last_z_args="$@"
    _z "$@"
  fi
}

zz() {
  cd "$(_z -l 2>&1 | sed 's/^[0-9,.]* *//' | fzf -q $_last_z_args)"
}

alias j=z
alias jj=zz

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
[[ -d $PYENV_ROOT ]] && eval "$(pyenv init -)" && eval "$(pyenv virtualenv-init -)"

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

# Base16 Shell
BASE16_SHELL="$HOME/.config/base16-shell/scripts/base16-eighties.sh"
[[ -s $BASE16_SHELL ]] && source $BASE16_SHELL

# add ~/bin directory to my path
if [ -d "$HOME/bin" ] ; then
    PATH="$PATH:$HOME/bin"
fi

PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"

unsetopt share_history

# Fix the bug with renaming windows
DISABLE_AUTO_TITLE=true

# Fix c-u for zsh
bindkey \^U backward-kill-line

# virtualenv-wrapper
export WORKON_HOME=~/.virtualenvs
source /usr/local/bin/virtualenvwrapper.sh

# Inherit environment if its activated
if [ -n "$VIRTUAL_ENV" ]; then
  . "$VIRTUAL_ENV/bin/activate"
fi

[[ $TMUX = "" ]] && export TERM="xterm-256color" || TERM="screen-256color"

[[ -s $HOME/.zshrc.local ]] && source $HOME/.zshrc.local

autoload edit-command-line
zle -N edit-command-line
bindkey '^Xe' edit-command-line
