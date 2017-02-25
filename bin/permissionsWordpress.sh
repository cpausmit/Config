#!/bin/bash

# the wordpress base directory (our blog)
WP_DIR=/var/www/html/blog

if ! [ -d $WP_DIR ]
then
  echo ""
  echo " No wordpress directory installed. EXIT!"
  echo ""
  exit 1
fi
    
# set the ownership (recursive)
sudo chown -R apache:apache $WP_DIR

# set the permissions for all files and directories (minimal and recursive)
sudo find $WP_PRESS -type d -exec chmod 755 {} \;
sudo find $WP_PRESS -type f -exec chmod 644 {} \;

# done
exit 0
