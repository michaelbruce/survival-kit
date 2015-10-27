# bashrc for OSX/Arch Linux

# System Defaults {{{

export PLATFORM=$(uname -s)
[ -f /etc/bashrc ] && . /etc/bashrc

BASE=$(dirname $(readlink $BASH_SOURCE))

### Append to the history file
shopt -s histappend

### Check the window size after each command ($LINES, $COLUMNS)
shopt -s checkwinsize

### Better-looking less for binary files
[ -x /usr/bin/lesspipe    ] && eval "$(SHELL=/bin/sh lesspipe)"

### Bash completion
[ -f /etc/bash_completion ] && . /etc/bash_completion

### Disable CTRL-S and CTRL-Q
[[ $- =~ i ]] && stty -ixoff -ixon

### Resume with C-z
stty susp undef
bind '"\C-z":"zorv\015"'

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
  export PATH=~/.rbenv/bin:~/miniconda/bin:~/bin:~/ruby:/opt/bin:/usr/local/bin:/usr/local/share/python:/usr/local/opt/go/libexec/bin:$PATH
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

alias j='jobs'
alias r='source ~/.bashrc'
alias l='ls -alF'
alias ll='ls -a'
alias cal='gcalcli'
alias d='cs'
alias .d='cd ~/dotfiles'
alias .n='cd ~/notes'
alias rv='rbenv versions'
alias op='cd ~/Workspace/'
alias b='bundle exec rake spec'
alias bi='bundle install'
alias be='bundle exec'
alias bu='bundle update'
alias rk='xmodmap ~/.Xmodmap'
alias q='ruby ~/dotfiles/scripts/status_overview.rb'
alias apu='ant pushToMyOrg'
alias adr='ant deployResources'
alias mi='make install'
alias mp='mvn package'
alias mci='mvn clean install'
alias bp='be rspec spec/processors'
alias m='mutt'
alias i='pry'
alias k='python'
alias p8='ping 8.8.8.8'
alias pgstart='sudo systemctl start postgresql'
alias mc='minecraft'
alias ir='pry ~/dotfiles/scripts/pry_read.rb'
alias cl='for code in {0..255}; do echo -e "\e[38;05;${code}m $code: Test"; done' #print colors
alias fv='fg %1'
alias fb='fg %2'
alias fn='fg %3'
alias t='tmux_connect'
alias y='evelyn-tree'
alias vs='vim --startuptime ~/.startup.log'
alias ns='nvim --startuptime ~/.startup_nvim.log'
alias gi='gem install'
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
alias cm='cmatrix -a -C magenta'
alias da='date'
alias j='jobs'
alias x='sudo xkill'

# Location aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias jk='jekyll'
alias sf='cd ~/Workspace/focal-pointer/'
alias se='cd ~/Workspace/Singletrack-Email-Distribution'
alias sm='cd ~/Workspace/Singletrack-Monitor'
alias sa='d ~/Workspace/Singletrack-Analytics'
alias sc='d ~/Workspace/Singletrack-Core'
alias sj='cd ~/Workspace/Singletrack-Job-Processor'
alias sp='cd ~/Workspace/Singletrack-Portal'
alias sw='cd ~/Workspace/Singletrack-Watermarker'
alias sdm='cd ~/Workspace/Singletrack-Data-Migration'
alias sm='cd ~/Workspace/Singletrack-Monitor'
alias sd='cd ~/Workspace/Singletrack-Core/SingletrackDev'
alias scc='clear && d ~/Workspace/Singletrack-Customer-Customisations'
alias neo='cd ~/Workspace/neovim'
alias oot='cd ~/Workspace/oot2d-cljs'
alias doc='cd ~/Documents'
alias dl='cd ~/Downloads'
alias dt='d ~/Desktop'
alias n='d ~/Workspace/scratchland/'
alias mu='d ~/Music && cmus'
alias sound='pavucontrol'
alias ggwp='sudo shutdown -h 0'
alias pi='sudo pacman -S'
alias pup='sudo pacman -Sy'
alias pall='sudo pacman -Syu'
alias pr='sudo pacman -R'
alias sx='startx'
alias ri='PAGER="less -R" ri -f ansi'
alias pu='pu_prompt'
alias po='popd'

# Development aliases
alias hl='color_heroku_logs'
alias ha='heroku apps'
alias hr='heroku run -a'
alias hs='heroku ps:scale web=0'

# Git aliases
alias gl='git log'
alias f='git diff'
alias gs='git status'
alias co='git checkout'
alias gcf='git clean -f'
alias gdt='git difftool'
alias gla='git listall'
alias s='git status'
alias a='git add'
alias ap='git add -p'
alias c='git commit -v -m'
alias c!='git commit --amend'
alias u='git-up'
alias p='git push'
alias g='git l -20'
alias gg='git l'
alias ungc='git reset --soft HEAD~1'
alias clo='git clone'
alias gdc='git diff --cached' # diff staged files
alias gsu='git submodule update'
alias gsh='git show'
alias gb='git branch'
alias gba='git branch -a'
alias gsp='git submodule foreach "git pull"'
alias gd='git diff'
alias grt='d $(git rev-parse --show-toplevel || echo ".")'
alias gf='git fetch'
alias gfi='git flow init'
alias gffs='git flow feature start'
alias gfff='git flow feature finish'
alias gffp='git flow feature publish'
alias gr='git remote'
alias grem="git config --global credential.helper 'cache --timeout=3600'"
alias grb='git ls-remote --heads origin'
alias grv='git remote -v'
alias gcl='git config --list'
alias gcp='git cherry-pick'
alias gcount='git shortlog -sn'
alias gall='ruby ~/dotfiles/scripts/git_commit_counter.rb'
alias gst='git stash'
alias gstp='git stash pop'
alias gsts='git stash show'
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

PS1="\w(\[\$TIME\]\[\$GIT\]) "

# if which tmux 2>&1 >/dev/null; then # Always work in a tmux session if tmux is installed
#     if [ $TERM != "screen-256color" ] && [  $TERM != "screen" ] && [ $TERM != "linux" ] && [ $TERM != "eterm-color" ]; then
#         tmux attach -t o || tmux new -s o; exit
#     fi
# fi

# }}}
# Custom Functions {{{

clear_color ()
{
    echo -ne "\033[0m"
}

pu_prompt ()
{
  new_dir="$*";
  if [ $# -eq 0 ]; then
    new_dir="$HOME";
  fi;
  pushd "${new_dir}"
}

git_prompt ()
{
  echo -e "$(branch_color)$(parse_git_branch)$(clear_color)"
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

c_green=`tput setaf 2`
c_magenta=`tput setaf 14`
c_yellow=`tput setaf 11`
c_blue=`tput setaf 4`

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

zorv () {
  if [[ -z $(jobs) ]]; then
    vim
  else
    fg
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

    echo -ne "$color$minutes"
    clear_color
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
