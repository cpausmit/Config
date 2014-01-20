#!/bin/bash
#===================================================================================================
# Sent email to request to be pu in the waiting list for a room in the CERN Hostel.
# 
#===================================================================================================

epoche=`date +%s`
tomorrow=$(( $epoche + 86400))
dateTomorrow=`date -d @$tomorrow +"%d.%m.20%y"`

rm    -f /tmp/emailWaitingList.$$
touch    /tmp/emailWaitingList.$$
echo ""                                                               >> /tmp/emailWaitingList.$$  
echo "Dear folks at the hostel;"				      >> /tmp/emailWaitingList.$$
echo ""								      >> /tmp/emailWaitingList.$$
echo "could you please put me on the waiting list for $dateTomorrow?" >> /tmp/emailWaitingList.$$
echo ""								      >> /tmp/emailWaitingList.$$
echo "Thank you, Christoph"                                           >> /tmp/emailWaitingList.$$

#EMAIL=paus@mit.edu
EMAIL=cern.hostel@cern.ch

mail -S replyto=paus@mit.edu -c paus@mit.edu \
     -s "Waiting List for tomorrow ($dateTomorrow, Single in CERN Hostel)" $EMAIL \
     < /tmp/emailWaitingList.$$

crontab -r
echo " Deleted crontab."
echo "  -> return code: $?"

exit 0

## using crontab: entry (Nov 14 at 13:59 MIT -> 19:59 CERN)
# 59 13 14 11 * /home/paus/bin/sentWaitingListEmail.sh
# 59 13 15 11 * /home/paus/bin/sentWaitingListEmail.sh

# 06 04 15 11 * /home/paus/bin/sentWaitingListEmail.sh

## using at (NOT YET WORKING)
# at -f ~/bin/sentWaitingListEmail.sh 13:59 Nov 14
