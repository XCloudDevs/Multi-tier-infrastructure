#!/bin/bash
sudo -s
yum update
yum install httpd php-mysql -y
amazon-linux-extras install -y php7.3
cd /var/www/html
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
cp -r wordpress/* /var/www/html/
rm -rf wordpress
rm -rf latest.tar.gz
chmod -R 755 wp-content
chown -R apache:apache wp-content
# Create a WordPress config file 
cp wp-config-sample.php wp-config.php
#set database details with perl find and replace
sed -i "s/database_name_here/wordpress/g" /var/www/html/wp-config.php
sed -i "s/username_here/wpadmin/g" /var/www/html/wp-config.php
sed -i "s/password_here/wpadminpass/g" /var/www/html/wp-config.php
sed -i "s/localhost/172.168.1.136/g" /var/www/html/wp-config.php
service httpd start
chkconfig httpd on