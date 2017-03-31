# Source global definitions

if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# User specific environment and startup programs
function parse_git_branch () {   git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/';  }
#PS1="\[\033[1;31m\][\$(date +%H:%M)]\[\033[1;30m\][\u@\h:\[\033[1;31m\]\w]\[\033[0m\] "
#PS1="[\[\033[1;31m\]\$(date +%H:%M)-\[\033[1;30m\]\u@\h:\[\033[1;34m\]\$MIT_VERS:\[\033[0m\]\[\033[1;32m\]\w\[\033[0m\]] "
PS1="[\[\033[1;31m\]\$(date +%H:%M)-\$(parse_git_branch)-\[\033[1;30m\]\u@\h:\[\033[1;32m\]\w\[\033[0m\]] "

PATH=$HOME/bin:$HOME/bin/photos:/bin:/usr/bin:/usr/local/bin:/usr/bin/X11
PATH=${PATH}:/usr/krb5/bin:/usr/kerberos/bin:/sbin:/usr/sbin
export PATH

export EDITOR=emacs
export VISUAL=emacs

TEXINPUTS="${TEXINPUTS}:/home/$USER/latex/sty:/home/$USER/latex/def:.";
TEXINPUTS="${TEXINPUTS}:/usr/share/texlive/texmf-dist/tex/latex/base:/usr/share/texlive/texmf-dist/tex/latex/xcolor"
export TEXINPUTS

# Set general alias

alias clb="clean.csh backup"
alias cll="clean.csh backup-local"
alias clc="clean.csh core"
alias recent="findRecentFiles 1 ./"
alias large="find $HOME -size +8000k -exec ls -sh {} \;"
alias xterm="xterm -fa monospace -fs 16"

# Set other more specific aliases if appropriate

if [ -f "/home/$USER/CmsSetup/init.sh" ]
then
  # initialize the cms aliases
  source $HOME/.aliases-cms
  source /home/cmsprod/Tools/Dools/setup.sh
  source /home/cmsprod/Tools/T2Tools/setup.sh
fi

if [ "`which git 2> /dev/null`" != "" ] && ! [ -e "/$HOME/.gitconfig" ]
then
  git config --global user.name    "Christoph Paus"
  git config --global user.email   paus@mit.edu
  git config --global push.default simple
fi

# Panda
alias panda002='export MIT_VERS=002;export MIT_TAG=master; mkdir -p $C/$MIT_VERS;cd $C/$MIT_VERS;source $S/init.sh 8_0_26_patch1; cd $J'

alias monojet000='export MIT_VERS=000;export MIT_TAG=master; mkdir -p $C/$MIT_VERS;cd $C/$MIT_VERS;source $S/init.sh 8_0_26_patch1; cd $J'

## source /home/paus/Panda/FiBS/setup.sh
source /home/cmsprod/Tools/FiBS/setup.sh
