#dnf install cairo-devel libjpeg-turbo-devel libpng-devel uuid-devel freerdp-devel pango-devel libssh2-devel libssh-devel tomcat tomcat-admin-webapps tomcat-webapps libvncserver-devel freerdp1.2 freerdp-libs -y
dnf install cairo-devel libjpeg-turbo-devel libpng-devel uuid-devel pango-devel libssh-devel libvncserver freerdp freerdp-libs -y

dnf install java-1.8.0-openjdk-devel -y

cd /usr/local
wget http://www-us.apache.org/dist/tomcat/tomcat-9/v9.0.24/bin/apache-tomcat-9.0.24.tar.gz
tar -xvf apache-tomcat-9.0.24.tar.gz
mv apache-tomcat-9.0.24 tomcat

useradd -r tomcat
chown -R tomcat:tomcat /usr/local/tomcat

export http_proxy=proxy.man.ac.uk:3128
export https_proxy=proxy.man.ac.uk:3128

wget http://sourceforge.net/projects/guacamole/files/current/source/guacamole-server-0.9.9.tar.gz 
tar zxf guacamole-server-0.9.9.tar.gz 

cd guacamole-server-0.9.9 
./configure 

make
make install

ldconfig
service
cd /var/lib/tomcat
wget http://sourceforge.net/projects/guacamole/files/current/binary/guacamole-0.9.9.war
mv guacamole-0.9.9.war guacamole.war

for i in /etc/guacamole /usr/local/tomcat/.guacamole;
do
	if [ ! -d $i ]; then
		mkdir $i
	fi
done

echo -e "guacd-hostname: localhost\nguacd-port:    4822\nuser-mapping:    /etc/guacamole/user-mapping.xml\nauth-provider:    net.sourceforge.guacamole.net.basic.BasicFileAuthenticationProvider\nbasic-user-mapping:    /etc/guacamole/user-mapping.xml" > /etc/guacamole/guacamole.properties

ln -s /etc/guacamole/guacamole.properties /usr/local/tomcat/.guacamole/
chmod 644 /etc/guacamole/guacamole.properties

md5=`printf '%s' "tecmint01" | md5sum | cut -c-32`
echo -e "<user-mapping>\n\t<authorize\n\t\tusername=\"tecmint\"\n\t\tpassword=\"$md5\"\n\t\tencoding=\"md5\">\n\t\t<connection name=\"RHEL 7\">\n\t\t\t<protocol>ssh</protocol>\n\t\t\t<param name=\"hostname\">10.0.2.20</param>\n\t\t\t<param name=\"port\">22</param>\n\t\t\t<param name=\"username\">vagrant</param>\n\t\t</connection>\n\t\t<connection name=\"Linux Desktop\">\n\t\t\t<protocol>vnc</protocol>\n\t\t\t<param name=\"hostname\">10.0.2.21</param>\n\t\t\t<param name=\"port\">5900</param>\n\t\t</connection>\n\t</authorize>\n</user-mapping>" > /etc/guacamole/user-mapping.xml
chmod 600 /etc/guacamole/user-mapping.xml
chown tomcat:tomcat /etc/guacamole/user-mapping.xml

TOMCAT_USERS="/usr/local/tomcat/conf/tomcat-users.xml"
echo -e "<?xml version='1.0' encoding='utf-8'?>" > $TOMCAT_USERS
echo -e "<tomcat-users>" >> $TOMCAT_USERS
echo -e "<user name=\"admin\" password=\"adminadmin\" roles=\"admin,manager,admin-gui,admin-script,manager-gui,manager-script,manager-jmx,manager-status\" />" >> $TOMCAT_USERS
echo -e "</tomcat-users>" >> $TOMCAT_USERS

TOMCAT_SERVICE="/etc/systemd/system/tomcat.service"
echo -e "[Unit]" > $TOMCAT_SERVICE
echo -e "Description=Apache Tomcat Server" >> $TOMCAT_SERVICE
echo -e "After=syslog.target network.target" >> $TOMCAT_SERVICE
echo -e "" >> $TOMCAT_SERVICE
echo -e "[Service]" >> $TOMCAT_SERVICE
echo -e "Type=forking" >> $TOMCAT_SERVICE
echo -e "User=tomcat" >> $TOMCAT_SERVICE
echo -e "Group=tomcat" >> $TOMCAT_SERVICE
echo -e "" >> $TOMCAT_SERVICE
echo -e "Environment=CATALINA_PID=/usr/local/tomcat/temp/tomcat.pid" >> $TOMCAT_SERVICE
echo -e "Environment=CATALINA_HOME=/usr/local/tomcat" >> $TOMCAT_SERVICE
echo -e "Environment=CATALINA_BASE=/usr/local/tomcat" >> $TOMCAT_SERVICE
echo -e "" >> $TOMCAT_SERVICE
echo -e "ExecStart=/usr/local/tomcat/bin/catalina.sh start" >> $TOMCAT_SERVICE
echo -e "ExecStart=/usr/local/tomcat/bin/catalina.sh stop" >> $TOMCAT_SERVICE
echo -e "" >> $TOMCAT_SERVICE
echo -e "RestartSec=10" >> $TOMCAT_SERVICE
echo -e "Restart=always" >> $TOMCAT_SERVICE
echo -e "[Install]" >> $TOMCAT_SERVICE
echo -e "WantedBy=multi-user.target" >> $TOMCAT_SERVICE
echo -e "" >> $TOMCAT_SERVICE

systemctl daemon-reload

systemctl enable tomcat
systemctl start tomcat
/usr/local/sbin/guacd

