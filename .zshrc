#
# zplug
#
source ~/.zplug/zplug
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-syntax-highlighting"
zplug "simnalamburt/cgitc"
zplug "simnalamburt/shellder"
zplug load


#
# zsh-sensible
#
stty stop undef
export LS_COLORS="$LS_COLORS:di=1;94"

alias l='ls -lah'
alias mv='mv -i'
alias cp='cp -i'

setopt auto_cd
zstyle ':completion:*' menu select


#
# lscolors
#
autoload -U colors && colors
export LSCOLORS="Gxfxcxdxbxegedabagacad"
export LS_COLORS="di=1;36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=0;42:ow=0;43:"
export TIME_STYLE="+%y%m%d"
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# Find the option for using colors in ls, depending on the version: Linux or BSD
if [[ "$(uname -s)" == "NetBSD" ]]; then
  # On NetBSD, test if "gls" (GNU ls) is installed (this one supports colors);
  # otherwise, leave ls as is, because NetBSD's ls doesn't support -G
  gls --color -d . &>/dev/null 2>&1 && alias ls='gls --color=tty'
elif [[ "$(uname -s)" == "OpenBSD" ]]; then
  # On OpenBSD, "gls" (ls from GNU coreutils) and "colorls" (ls from base,
  # with color and multibyte support) are available from ports.  "colorls"
  # will be installed on purpose and can't be pulled in by installing
  # coreutils, so prefer it to "gls".
  gls --color -d . &>/dev/null 2>&1 && alias ls='gls --color=tty'
  colorls -G -d . &>/dev/null 2>&1 && alias ls='colorls -G'
else
  ls --color -d . &>/dev/null 2>&1 && alias ls='ls --color=tty' || alias ls='ls -G'
fi


#
# zsh-substring-completion
#
setopt complete_in_word
setopt always_to_end
WORDCHARS=''
zmodload -i zsh/complist

# Substring completion
zstyle ':completion:*' matcher-list 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

## Case-insensitive substring completion
#zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

## Case-insensitive & hyphen-insensitive substring completion
#zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'


#
# fzy.zsh
#
if hash fzy 2>/dev/null; then
  [ -z "$HISTFILE" ] && HISTFILE=$HOME/.zsh_history
  HISTSIZE=10000
  SAVEHIST=10000
  function fzy-history-widget() {
    echo
    setopt localoptions pipefail
    BUFFER=$(fc -l 1 | perl -pe 's/^\s*\d+\s+/  /' | tac | awk '!a[$0]++' | fzy -l25 --query=$LBUFFER | cut -c3-)
    CURSOR=$#BUFFER
    local ret=$?
    zle reset-prompt
    return $ret
  }
  zle     -N    fzy-history-widget
  bindkey '^R'  fzy-history-widget
fi


#
# zshrc
#
if [ -f ~/.fzf.zsh ]; then; source ~/.fzf.zsh; fi
if [ "$TMUX" = "" ]; then; export TERM="xterm-256color"; fi
export DEFAULT_USER="$USER" # TODO: https://github.com/simnalamburt/shellder/issues/10

# Aliases
if hash nvim 2>/dev/null; then; alias vim='nvim'; fi # neovim
if hash tmux 2>/dev/null; then; alias irc='tmux attach -t irc'; fi
if hash ledit 2>/dev/null; then
  alias ocaml='ledit ocaml'
  alias racket='ledit racket'
fi

# Ruby
if hash ruby 2>/dev/null && hash gem 2>/dev/null; then
  export GEM_HOME=$(ruby -e 'print Gem.user_dir')
  export PATH="$PATH:$GEM_HOME/bin"
fi

# Golang
if hash go 2>/dev/null; then
  export GOPATH=~/.go
  mkdir -p $GOPATH
  export PATH="$PATH:$GOPATH/bin"
fi

# Rust
if hash rustc 2>/dev/null; then
  export RUST_BACKTRACE=1
fi
if hash cargo 2>/dev/null; then
  export PATH="$PATH:$HOME/.cargo/bin"
fi
