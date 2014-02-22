# Source global definitions

if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# User specific environment and startup programs

PS1="\[\033[1;31m\][\$(date +%H:%M)]\[\033[1;30m\][\u@\h:\[\033[1;31m\]\w]\[\033[0m\] "

PATH=$HOME/bin:/bin:/usr/bin:/usr/local/bin:/usr/bin/X11
PATH=${PATH}:/usr/krb5/bin:/usr/kerberos/bin:/sbin:/usr/sbin
export PATH

export EDITOR=emacs
export VISUAL=emacs

TEXINPUTS="/home/$USER/text/sty:/home/$USER/text/sty/foiltex";
TEXINPUTS="${TEXINPUTS}:/home/$USER/text/def:/home/$USER/teaching/text/def";
TEXINPUTS="${TEXINPUTS}:/home/$USER/text/oo";
TEXINPUTS="${TEXINPUTS}:/home/$USER/teaching/text/sty";
TEXINPUTS="${TEXINPUTS}:/home/$USER/text/revtex4";
TEXINPUTS="${TEXINPUTS}:/usr/share/texmf/tex/generic/pstricks:";
export TEXINPUTS

# Set general alias

alias clb="clean.csh backup"
alias cll="clean.csh backup-local"
alias clc="clean.csh core"
alias recent="findRecentFiles 1 ./"
alias large="find $HOME -size +8000k -exec ls -sh {} \;"

# Set other more specific aliases if appropriate

if [ -f "/home/$USER/cms/INIT" ]
then
  # initialize the cms aliases
  source $HOME/.aliases-cms
fi

if [ "`which git 2> /dev/null`" != "" ] && ! [ -e "/$HOME/.gitconfig" ]
then
  git config --global user.name    "Christoph Paus"
  git config --global user.email   paus@mit.edu
  git config --global push.default simple
fi
