# bashrc for OSX/Arch Linux

# System Defaults {{{

export PLATFORM=$(uname -s)
[ -f /etc/bashrc ] && . /etc/bashrc

BASE=$(dirname $(readlink $BASH_SOURCE))

shopt -s histappend # Append to the history file
shopt -s checkwinsize # Check the window size after each command

### Better-looking less for binary files
[ -x /usr/bin/lesspipe    ] && eval "$(SHELL=/bin/sh lesspipe)"

[ -f /etc/bash_completion ] && . /etc/bash_completion

### Disable CTRL-S and CTRL-Q
[[ $- =~ i ]] && stty -ixoff -ixon

#}}}
# Environment Variables {{{

### man bash
export HISTCONTROL=ignoreboth:erasedups
export HISTSIZE=
export HISTFILESIZE=
export HISTTIMEFORMAT="%Y/%m/%d %H:%M:%S:   "
[ -z "$TMPDIR" ] && TMPDIR=/tmp

VIMRUNTIME=/usr/local/bin/vim

### Use color with ri
RI="--format ansi --width 80"

### Global
if [ -z "$PATH_EXPANDED" ]; then
  export PATH=~/.rbenv/bin:~/miniconda/bin:~/survival-kit/bin:~/ruby:/opt/bin:/usr/local/bin:/usr/local/share/python:/usr/local/opt/go/libexec/bin:$PATH
  export PATH_EXPANDED=1
fi

eval "$(rbenv init -)"
export EDITOR=vim
export LANG=en_US.UTF-8
if [[ "$OSTYPE" == "darwin"* ]]; then
  export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:.:/usr/local/lib
  export JAVA_HOME='/Library/Java/JavaVirtualMachines/jdk1.8.0_60.jdk/Contents/Home'

  ### OS X
  export COPYFILE_DISABLE=true
fi

#}}}
# Aliases {{{

alias sk='d ~/survival-kit/'
alias r='source ~/.bashrc'
alias l='ls -alF'
alias ll='ls -a'
alias d='cs'
alias .d='cd ~/dotfiles'
alias .n='cd ~/notes'
alias .k='cd ~/survival-kit'
alias rv='rbenv versions'
alias op='cd ~/code/'
alias b='bundle exec rake spec'
alias bi='bundle install'
alias be='bundle exec'
alias mi='make install'
alias bp='be rspec spec/processors'
alias m='mutt'
alias pgstart='sudo systemctl start postgresql'
alias cl='for code in {0..255}; do echo -e "\e[38;05;${code}m $code: Test"; done' #print colors
alias t='tmux_connect'
alias y='evelyn-tree'
alias o='nautilus . &'
alias ac='acpi'
if [[ "$OSTYPE" == "darwin"* ]]; then
  alias o="open ."
  alias acpi="pmset -g batt"
  alias pi='brew install'
  alias ctags="`brew --prefix`/bin/ctags"
  alias pgstart='pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start'
fi
alias ct='ctags -R --extra=+q --exclude=.git --exclude=log --langmap=java:.cls.trigger  -f $(git rev-parse --show-toplevel)/.tags . $(bundle list --paths)'

# Location aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias jk='jekyll'
alias sf='cd ~/code/focal-pointer/'
alias se='cd ~/code/Singletrack-Email-Distribution'
alias sm='cd ~/code/Singletrack-Monitor'
alias sa='d ~/code/Singletrack-Analytics'
alias sc='d ~/code/Singletrack-Core'
alias sj='cd ~/code/Singletrack-Job-Processor'
alias sp='cd ~/code/Singletrack-Portal'
alias sw='cd ~/code/Singletrack-Watermarker'
alias sdm='cd ~/code/Singletrack-Data-Migration'
alias sm='cd ~/code/Singletrack-Monitor'
alias sd='cd ~/code/Singletrack-Core/SingletrackDev'
alias scc='clear && d ~/code/Singletrack-Customer-Customisations'
alias doc='cd ~/Documents'
alias dl='cd ~/Downloads'
alias dt='d ~/Desktop'
alias n='d ~/code/scratchland/'
alias ggwp='sudo shutdown -h 0'
alias sx='startx'
alias ri='PAGER="less -R" ri -f ansi'
alias hl='color_heroku_logs'

# Git aliases
alias f='git diff'
alias co='git checkout'
alias gcf='git clean -f'
alias gla='git listall'
alias s='git status'
alias a='git add'
alias ap='git add -p'
alias c='git commit -v -m'
alias c!='git commit --amend'
alias u='git-up'
alias p='git push'
alias g='git l -20'
alias ungc='git reset --soft HEAD~1'
alias clo='git clone'
alias gdc='git diff --cached' # diff staged files
alias gsh='git show'
alias gb='git branch'
alias gba='git branch -a'
alias grt='d $(git rev-parse --show-toplevel || echo ".")'
alias gf='git fetch'
alias gfi='git flow init'
alias fs='git flow feature start'
alias ff='git flow feature finish'
alias fp='git flow feature publish'
alias gr='git remote'
alias grb='git ls-remote --heads origin'
alias grv='git remote -v'
alias gcl='git config --list'
alias gcp='git cherry-pick'
alias gcount='git shortlog -sn'
alias gall='ruby ~/dotfiles/scripts/git_commit_counter.rb'
alias gm='git merge'
alias grh='git reset HEAD'
alias grhh='git reset HEAD --hard'

### Colored ls
if [ -x /usr/bin/dircolors ]; then
  eval "`dircolors -b`"
  alias ls='ls --color=auto'
  alias grep='grep --color=auto'
elif [ "$PLATFORM" = Darwin ]; then
  alias ls='ls -G'
fi

# }}}
# Prompt {{{

shopt -s nocaseglob #case insensitive completion
export LSCOLORS="ExGxBxDxCxEgEdxbxgxcxd"

PROMPT_COMMAND='TIME=$(time_prompt) && GIT=$(git_prompt)'

PS1="\w(\$TIME\$GIT) $ "

# }}}
# Custom Functions {{{

c_clear="\033[0m"
c_green=`tput setaf 2`
c_magenta=`tput setaf 14`
c_yellow=`tput setaf 11`
c_blue=`tput setaf 4`

git_prompt ()
{
  echo -e "$(branch_color)$(parse_git_branch)$c_clear"
}

parse_git_branch ()
{
  if git rev-parse --git-dir >/dev/null 2>&1
  then
          gitver="$(git branch 2>/dev/null| sed -n '/^\*/s/^\* //p')"
  else
          return 0
  fi
  echo -e "$gitver"
}

branch_color ()
{
  if git rev-parse --git-dir >/dev/null 2>&1
  then
    color=""
    if git diff --quiet 2>/dev/null >&2
    then
      color="${c_green}"
    else
      color="${c_magenta}"
    fi
  else
    return 0
  fi
  echo -ne $color
}

viw() {
  vim `which "$1"`
}

color_heroku_logs() {
  heroku logs --tail -a $1 |
  ack --flush --color --passthru --color-match=yellow "^.*host.*" |
  ack --flush --color --passthru --color-match=red "^.*ERROR.*" |
  ack --flush --color --passthru --color-match=red "^.*Exception*" |
  ack --flush --color --passthru --color --color-match=green "^.*INFO.*" |
  ack --flush --color --passthru --color --color-match=magenta "^.*FileFinder.*"
}

function cs() {
new_directory="$*";
if [ $# -eq 0 ]; then 
    new_directory=${HOME};
fi;

if [[ "$OSTYPE" == "darwin"* ]]; then
  builtin cd "${new_directory}" && ls -G
else
  builtin cd "${new_directory}" && ls --color
fi
}

evelyn-tree() {
  tree_depth="$*";
  if [ $# -eq 0 ]; then
      tree_depth=1;
  fi;
  tree -d -L "${tree_depth}"
}

function minutes_since_last_commit {
    now=`date +%s`
    last_commit=`git log --pretty=format:'%at' -1`
    seconds_since_last_commit=$((now-last_commit))
    minutes_since_last_commit=$((seconds_since_last_commit/60))
    echo $minutes_since_last_commit
}

function time_prompt {
    if git rev-parse --git-dir > /dev/null 2>&1; then
      local minutes=`minutes_since_last_commit`
    else
      local minutes='9000'
    fi

    color=''
    seperator='|'
    if (( $minutes < 30 )); then
      color="${c_green}"
    elif (( $minutes < 120 )); then
      color="${c_yellow}"
    elif (( $minutes > 4000 )); then
      color="${c_blue}"
      minutes="!"
      seperator=''
    else
      color="${c_magenta}"
    fi

    echo -ne "$color$minutes$c_clear"
    echo -ne "$seperator"
}


function tmux_connect {
  if which tmux 2>&1 >/dev/null; then
    if [ $TERM != "screen-256color" ] && [  $TERM != "screen" ]; then
      tmux attach -t home || tmux new -s home; exit
    fi
  fi
}

# }}}
