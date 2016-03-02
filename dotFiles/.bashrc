# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    #PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

    PS1="\[\e[0;32m\]\H\[\e[m\] \[\e[0;0m\]@\[\e[m\] \[\e[0;34m\]\W\[\e[m\] \$ "
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    #alias ls='ls --color=auto'
    alias ls="ls --color=auto -h --group-directories-first -X"
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi



######################
####### custom #######
######################

complete -cf sudo
complete -cf man
complete -cf gksu

## turn off bell
if [ -n "$DISPLAY" ]; then
    xset b off
fi

alias sudo="sudo "
alias fucking="sudo "
alias new="(xterm &)"
alias emacs="emacs --no-splash -u '$USER'"
alias e="'emacsclient' -c"
alias ewm="'emacs' --no-splash -u '$USER'"
alias ero="'emacs' --no-splash -u '$USER' --eval '(setq buffer-read-only t)'"

export ALTERNATE_EDITOR=""

alias top="'top' -o %CPU c"

alias R="R --quiet --no-save"
alias aspell="aspell -d en"
alias shutdown="sudo shutdown 0"
alias reboot="sudo reboot"



R-batch(){
    "/usr/lib/R/bin/R" CMD BATCH "$1"
}
R-comp-so(){
    export PKG_LIBS=`Rscript -e "Rcpp:::LdFlags()"`
    PKG_CXXFLAGS=`Rscript -e "Rcpp:::CxxFlags()"`
    compOpts="-fopenmp"
    export PKG_CXXFLAGS="$PKG_CXXFLAGS $compOpts"
    "/usr/lib/R/bin/R" CMD SHLIB "$1"
}


export GUROBI_HOME=/home/$USER/gurobi651/linux64
export GRB_LICENSE_FILE=$GUROBI_HOME/gurobi.lic

export PATH=$PATH:/home/$USER/bin:/home/$USER/Dropbox/bin:/home/$USER/.gem/ruby/2.2.0/bin:/opt/intel/bin:$GUROBI_HOME/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/intel/compilers_and_libraries_2016/linux/mkl/lib/intel64/:/opt/intel/compilers_and_libraries_2016/linux/lib/intel64:/usr/local/lib:$GUROBI_HOME/lib


if [ -n "$STY" ]; then export PS1="\[\e[1;31m\](screen)\[\e[m\] $PS1"; fi

export TERM=xterm-256color
export EDITOR="emacsclient -c"
export GREP_COLOR="01;36;41"


if [ -f /opt/ros/indigo/setup.bash ]
then
    source /opt/ros/indigo/setup.bash
fi

if [ -f ~/catkin_ws/devel/setup.bash ]
then
    source ~/catkin_ws/devel/setup.bash
fi
