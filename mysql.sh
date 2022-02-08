#!/bin/bash
sudo -s
yum update 
yum install mariadb-server -y
systemctl start mariadb
systemctl enable mariadb
mysqladmin -uroot create wordpress

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
create user "wpadmin"@"%" identified by "wpadminpass";
grant all privileges on *.* to "wpadmin"@"%" with grant option;
flush privileges;
SQL_QUERY

systemctl restart mariadb
