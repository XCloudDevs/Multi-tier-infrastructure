#!/bin/bash
sudo -s
yum update 
sudo dnf install @mysql:8.0 -y
sudo systemctl enable -now mysqld
sudo systemctl status mysqld

mysql_secure_installation <<EOF

y
password
password
y
y
y
y
EOF

mysql -uroot -ppassword <<SQL_QUERY
create database wordpress;
create user "wpadmin"@"%" identified by "wpadminpass";
grant all privileges on *.* to "wpadmin"@"%" with grant option;
flush privileges;
SQL_QUERY

systemctl restart mariadb
sed -i "s/=enforcing/=disabled/g" /etc/selinux/config
reboot

