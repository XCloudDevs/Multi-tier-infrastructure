#!/bin/bash
sudo -s
yum update 
yum install mariadb-server -y
systemctl start mariadb
systemctl enable mariadb
mysqladmin -uroot create wordpress
SECURE_MYSQL=$(expect -c "
set timeout 10
spawn mysql_secure_installation
 
expect \"Enter current password for root (enter for none):\"
send \"\r\"
 
expect \"Set root password?\"
send \"y\r\"
expect \"New password:\"
send \"password\r\"
expect \"Re-enter new password:\"
send \"password\r\"
expect \"Remove anonymous users?\"
send \"y\r\"
 
expect \"Disallow root login remotely?\"
send \"y\r\"
 
expect \"Remove test database and access to it?\"
send \"y\r\"
 
expect \"Reload privilege tables now?\"
send \"y\r\"
 
expect eof
")

mysql -uroot -ppassword <<SQL_QUERY
create user "wpadmin"@"%" identified by "wpadminpass";
grant all privileges on *.* to "wpadmin"@"%" with grant option;
# flush privileges;
SQL_QUERY

systemctl restart mariadb
