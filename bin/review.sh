#!/bin/bash
# ----
# Perfrom Energy Frontier Review
# ----
[ "$REVIEW_BASE" == "" ] && \
    REVIEW_BASE="$HOME/Documents/doe/EnergyFrontierPanel2015"

PATTERN="$1"

# fine our spot
cd $REVIEW_BASE

# open pdf documents
okular Proposal*${PATTERN}*.pdf &

# open Reviews/Notes
edit Review*${PATTERN}*.txt Notes*${PATTERN}*.txt

exit
