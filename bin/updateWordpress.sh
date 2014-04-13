#!/bin/bash
#---------------------------------------------------------------------------------------------------
# Keep these files/folders for wordpress
#
#  wp-config.php;
#  wp-content/;
#  wp-images/;
#  wp-includes/languages/
#  .htaccess file--if you have added custom rules to your .htaccess, do not delete it;
#
# Keep these files for private setup
#
#  README
#  robots.txt
#
#---------------------------------------------------------------------------------------------------
if ! [ -f "$1" ]
then
  echo " "
  echo " File does not exist: $1"
  echo " "
  echo " usage: updateWordpress.sh wordpressZipFile"
  echo " "
  exit 0
fi

pid=$$
mkdir -p ~/tmp/$pid

#---------------------------------------------------------------------------------------------------
# Safety copies for emergency recovery
#---------------------------------------------------------------------------------------------------
# make full sql dump of database
mysqldump -p paushaus_db > ~/tmp/$pid/paushaus_db.sql

# now stop mysql
sudo /etc/init.d/mysqld stop 

# make a backup
cp -r  /var/lib/mysql/paushaus_db ~/tmp/$pid/
cp -r ~/www/blog                  ~/tmp/$pid/

#---------------------------------------------------------------------------------------------------
# Remove what is not needed and will be overwritten by the upgrade anyway
#---------------------------------------------------------------------------------------------------
# not using any languages for now.... be careful!
cd ~/www/blog
rm -rf  wp-includes

# remove stuff we do not need

cd ~/www/blog
rm -rf  index.php
rm -rf  license.txt
rm -rf  new.wp
rm -rf  readme.html
rm -rf  wordpress_db.sql
rm -rf  wp-activate.php
rm -rf  wp-admin
rm -rf  wp-app.php
rm -rf  wp-atom.php
rm -rf  wp-blog-header.php
rm -rf  wp-comments-post.php
rm -rf  wp-commentsrss2.php
rm -rf  wp-config-sample.php
rm -rf  wp-cron.php
rm -rf  wp-feed.php
rm -rf  wp-links-opml.php
rm -rf  wp-load.php
rm -rf  wp-login.php
rm -rf  wp-mail.php
rm -rf  wp-pass.php
rm -rf  wp-rdf.php
rm -rf  wp-register.php
rm -rf  wp-rss2.php
rm -rf  wp-rss.php
rm -rf  wp-settings.php
rm -rf  wp-signup.php
rm -rf  wp-trackback.php
rm -rf  xmlrpc.php

#---------------------------------------------------------------------------------------------------
# Now get the new version
#---------------------------------------------------------------------------------------------------
# unzip new version
mv $1 ~/www/blog
cd    ~/www/blog
unzip `basename $1`
mv    `basename $1` ~/tmp/$pid

# move it to the present directory
mv wordpress/* ./

# upgrade
echo " "
echo " Finish upgrade in firefox with"
echo " "
echo " --> firefox http://paushaus.dyndns.org/blog/wp-admin/upgrade.php"
echo " "
#firefox http://paushaus.dyndns.org/blog/wp-admin/upgrade.php
