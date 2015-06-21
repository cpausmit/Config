[ -z $PROCESSING_BASE ] && export PROCESSING_BASE="$1"

export TICKET_HOLDER="paus"
export TIER2_USER="paus"

if [ -d  "$PROCESSING_BASE/bin" ]
then
  export MIT_PROD_DIR="$PROCESSING_BASE"
  export PATH="$HOME/bin:$PROCESSING_BASE/bin:${PATH}"
  export PYTHONPATH="$PROCESSING_BASE/python:${PYTHONPATH}"
  pVersion=`python --version 2>&1`
  pLocalVersion=`/usr/bin/python --version 2>&1`
  if [ "$pVersion" == "$pLocalVersion" ]
  then
    addedPath=`echo /usr/lib64/python*/site-packages`
    export PYTHONPATH="${PYTHONPATH}:$addedPath"
  else
    echo " Local python version not compatible with CMSSW release."
    echo " This might cause issues."
  fi
else
  echo ""
  echo " Setting up MitProd Processing failed! (\$PROCESSING_BASE = is empty)."
  echo ""
fi
