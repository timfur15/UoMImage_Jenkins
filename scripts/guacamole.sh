#!/bin/bash

cd /tmp
wget http://mirror.ox.ac.uk/sites/rsync.apache.org/guacamole/1.0.0/source/guacamole-server-1.0.0.tar.gz

tar xzf guacamole-server-1.0.0.tar.gz
cd guacamole-server-1.0.0
yum -y install cairo-devel libjpeg-devel libpng-devel uuid-devel freerdp-devel pango-devel libssh2-devel libssh-devel tomcat libvncserver-devel libtelnet-devel tomcat-admin-webapps tomcat-webapps gcc terminus-fonts fuse-devel freerdp1.2-devel
./configure
make
sudo make install
sudo ldconfig
cd ..
rm -rf guacamole-server-1.0.0*

wget http://www.mirrorservice.org/sites/ftp.apache.org/guacamole/1.0.0/binary/guacamole-1.0.0.war
mv guacamole-1.0.0.war /var/lib/tomcat/webapps/guacamole.war

mkdir -p /etc/guacamole
mkdir -p /usr/share/tomcat/.guacamole

ln -s /etc/guacamole/guacamole.properties /usr/share/tomcat/.guacamole/

#chmod 600 /etc/guacamole/user-mapping.xml
#chown tomcat:tomcat /etc/guacamole/user-mapping.xml

echo "guacamole.home=/etc/guacamole" >>/etc/tomcat/catalina.properties


cat << EOF > /etc/systemd/system/guacamole.service
    [Unit]
    Description=Guacamole Server
    Documentation=man:guacd(8)
    After=network.target
    [Service]
    User=root
    ExecStart=/usr/local/sbin/guacd -f
    Restart=on-abnormal
    [Install]
    WantedBy=multi-user.target
EOF

systemctl daemon-reload && systemctl start guacamole && systemctl enable guacamole && systemctl start tomcat && systemctl enable tomcat


#we need to add the setup for mysql and the setup for cas
yum -y install mariadb-server
systemctl enable mariadb
systemctl start mariadb
mysql --user=root <<_EOF_
UPDATE mysql.user SET Password=PASSWORD('${db_root_password}') WHERE User='root';
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
CREATE DATABASE guacamole_db;
CREATE USER 'guacamole_user'@'localhost' IDENTIFIED BY 'pi314159';
GRANT SELECT,INSERT,UPDATE,DELETE ON guacamole_db.* TO 'guacamole_user'@'localhost';
FLUSH PRIVILEGES;
_EOF_

#user_password="dcorbett"
#mysql --user=guacamole_user --password=pi314159 <<EOF
#connect guacamole_db;
#INSERT INTO guacamole_entity (name,type) VALUES ('mjkssdc6','USER');
#SET @entityid=LAST_INSERT_ID();
#SET @salt = UNHEX(SHA2(UUID(), 256));
#SET @password=UNHEX(SHA2(CONCAT('${user_password}',HEX(@salt)),256));
#INSERT INTO guacamole_user (entity_id,password_hash,password_salt,full_name,email_address,organization) VALUES (@entityid,@salt,@password,'Daniel Corbett','daniel.corbett@manchester.ac.uk','University of Manchester');
#SET @userid=LAST_INSERT_ID();
#INSERT IGNORE INTO guacamole_user_permission (entity_id,permission,affected_user_id) VALUES (@entityid,'READ',@userid),(@entityid,'UPDATE',@userid),(@entityid,'DELETE',@userid),(@entityid,'ADMINISTER',@userid);
#INSERT INTO guacamole_connection (connection_name,protocol,failover_only) VALUES ('Daniel Corbett RDP','rdp',0);
#SET @connectionid=LAST_INSERT_ID();
#INSERT IGNORE INTO guacamole_connection_permission (entity_id,permission,connection_id) VALUES (@entityid,'READ',@connectionid),(@entityid,'UPDATE',@connectionid),(@entityid,'DELETE',@connectionid),(@entityid,'ADMINISTER',@connectionid)
#INSERT INTO guacamole_connection (connection_name,protocol,failover_only) VALUES ('Daniel Corbett SSH','ssh',0);
#SET @connectionid=LAST_INSERT_ID();
#INSERT IGNORE INTO guacamole_connection_permission (entity_id,permission,connection_id) VALUES (@entityid,'READ',@connectionid),(@entityid,'UPDATE',@connectionid),(@entityid,'DELETE',@connectionid),(@entityid,'ADMINISTER',@connectionid)
#EOF

cd /tmp
wget http://www.mirrorservice.org/sites/ftp.apache.org/guacamole/1.0.0/binary/guacamole-auth-jdbc-1.0.0.tar.gz
wget http://mirror.vorboss.net/apache/guacamole/1.0.0/binary/guacamole-auth-cas-1.0.0.tar.gz
tar xzf guacamole-auth-jdbc-1.0.0.tar.gz
cd guacamole-auth-jdbc-1.0.0/mysql/schema

cat *.sql | mysql -u root --password=${db_root_password} guacamole_db
cd ..
mkdir -p /etc/guacamole/{extensions,lib}
cp guacamole-auth-jdbc-mysql-1.0.0.jar /etc/guacamole/extensions
cd /tmp
wget http://www.mirrorservice.org/sites/ftp.mysql.com/Downloads/Connector-J/mysql-connector-java-8.0.18.tar.gz
tar xzf mysql-connector-java-8.0.18.tar.gz
cp mysql-connector-java-8.0.18/mysql-connector-java-8.0.18.jar /etc/guacamole/lib/

cat <<EOF > /etc/guacamole/guacamole.properties
# Hostname and port of guacamole proxy
guacd-hostname: localhost
guacd-port:     4822
# MySQL properties
mysql-hostname: localhost
mysql-port: 3306
mysql-database: guacamole_db
mysql-username: guacamole_user
mysql-password: pi314159
mysql-default-max-connections-per-user: 0
mysql-default-max-group-connections-per-user: 0
EOF

firewall-cmd --zone=public --add-port=8080/tcp --permanent
firewall-cmd --reload
setsebool -P httpd_can_network_connect 1


yum -y install nginx
systemctl enable nginx
systemctl start nginx

cat <<EOF > /etc/nginx/conf.d/guacamole.conf
server {
    listen 80;
    server_name localhost;
        location /guacamole/ {
                proxy_pass http://localhost:8080/guacamole/;
                proxy_buffering off;
                proxy_http_version 1.1;
                proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
                proxy_set_header Upgrade \$http_upgrade;
                proxy_set_header Connection \$http_connection;
                access_log off;
        }
}
EOF

cat <<EOF> /etc/nginx/nginx.conf
# For more information on configuration, see:
#   * Official English Documentation: http://nginx.org/en/docs/
#   * Official Russian Documentation: http://nginx.org/ru/docs/

user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log;
pid /run/nginx.pid;

# Load dynamic modules. See /usr/share/doc/nginx/README.dynamic.
include /usr/share/nginx/modules/*.conf;

events {
    worker_connections 1024;
}

http {
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile            on;
    tcp_nopush          on;
    tcp_nodelay         on;
    keepalive_timeout   65;
    types_hash_max_size 2048;

    include             /etc/nginx/mime.types;
    default_type        application/octet-stream;

    # Load modular configuration files from the /etc/nginx/conf.d directory.
    # See http://nginx.org/en/docs/ngx_core_module.html#include
    # for more information.
    include /etc/nginx/conf.d/*.conf;
}
EOF

firewall-cmd --zone=public --add-port=80/tcp --permanent
firewall-cmd --reload
firewall-cmd --zone=public --add-port=443/tcp --permanent
firewall-cmd --reload
systemctl restart nginx

mkdir /shared




