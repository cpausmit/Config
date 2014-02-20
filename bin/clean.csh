#!/bin/tcsh -f
if      ( ".$1" == ".backup" ) then
  find $HOME \( -name \*.~\*~ -o -name \*~ -o -name \*.bak -o \
                -name .\*.~\*~ -o -name .\*~ -o -name .\*.bak \) \
       -exec ls -s {} \; -exec rm {} \;
else if ( ".$1" == ".backup-local" ) then
  find ./    \( -name \*.~\*~ -o -name \*~ -o -name \*.bak -o \
                -name .\*.~\*~ -o -name .\*~ -o -name .\*.bak \) \
       -exec ls -s {} \; -exec rm {} \;
else if ( ".$1" == ".core" ) then
  find $HOME -type f \( -name core -o -name core.\[0-9\]\* \) \
       -exec ls -s {} \; -exec rm {} \;
else if ( ".$1" == ".tex" ) then
  find $HOME/tex $HOME/teaching -type f \( -name \*.aux -o -name \*~ -o -name \*.dvi -o -name \*.log \) \
       -exec ls -s {} \; -exec rm {} \;
else
  echo ERROR - unknown request: \"$1\"
endif
