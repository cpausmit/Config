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

TEXINPUTS="${TEXINPUTS}:$HOME/latex/sty:$HOME/latex/def:.";
TEXINPUTS="${TEXINPUTS}:/usr/share/texlive/texmf-dist/tex/latex/base:/usr/share/texlive/texmf-dist/tex/latex/xcolor"
export TEXINPUTS

# Set other more specific aliases if appropriate

source $HOME/.alias
if [ -d "$HOME/Tools" ]
then
  # initialize the cms aliases
  source $HOME/.aliases-cms
  source $HOME/Tools/Dools/setup.sh
  source $HOME/Tools/T2Tools/setup.sh
  # Panda
  alias panda002='export MIT_VERS=002;export MIT_TAG=master; mkdir -p $C/$MIT_VERS;cd $C/$MIT_VERS;source $S/init.sh 8_0_26_patch1; cd $J'
  alias monojet000='export MIT_VERS=000;export MIT_TAG=master; mkdir -p $C/$MIT_VERS;cd $C/$MIT_VERS;source $S/init.sh 8_0_26_patch1; cd $J'
fi

if [ -f "$HOME/Tools/FiBS/setup.sh" ]
then
  source $HOME/Tools/FiBS/setup.sh
fi

if [ -d "$HOME/Work/Tapas" ]
then
  source $HOME/Work/Tapas/tools/setup.sh
fi

if [ -d "$HOME/Work/BulkEm" ]
then
  source $HOME/Work/BulkEm/setup.sh
fi

if [ "`which git 2> /dev/null`" != "" ] && ! [ -e "/$HOME/.gitconfig" ]
then
  git config --global user.name    "Christoph Paus"
  git config --global user.email   paus@mit.edu
  git config --global push.default simple
fi

### >>> conda initialize >>>
### !! Contents within this block are managed by 'conda init' !!
##__conda_setup="$('/home/submit/roche/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
##if [ $? -eq 0 ]; then
##    eval "$__conda_setup"
##else
##    if [ -f "/home/submit/roche/miniconda3/etc/profile.d/conda.sh" ]; then
##        . "/home/submit/roche/miniconda3/etc/profile.d/conda.sh"
##    else
##        export PATH="/home/submit/roche/miniconda3/bin:$PATH"
##    fi
##fi
##unset __conda_setup
### <<< conda initialize <<<

