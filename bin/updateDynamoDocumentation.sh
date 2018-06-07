#!/bin/bash
#
# Little script to completely update the dynamo documentation.
#

pwd=`pwd`
basedir=`basename $pwd`
if [ "$basedir" != 'dynamo-docs' ]
then
    echo ' ERROR - you are not in the right directory. [should be: dynamo-docs]'
    exit 1
fi

git pull
echo -n "continue ? [N/y]"
read YES
if [ "$YES" != 'y' ]
then
    echo "EXIT - fix the pull"
    exit 0
fi

git commit -am 'Working on v0.0'
git push -u origin master

sphinx-build -a -E . ~/dynamo-documentation

rsync -Cavz --delete ~/dynamo-documentation t3home000.mit.edu:public_html

exit 0
