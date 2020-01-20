yum install cairo-devel libjpeg-devel libpng-devel uuid-devel freerdp-devel pango-devel libssh2-devel libssh-devel tomcat tomcat-admin-webapps tomcat-webapps libvncserver-devel freerdp1.2 freerdp-libs -y

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

for i in /etc/guacamole /usr/share/tomcat/.guacamole;
do
	if [ ! -d $i ]; then
		mkdir $i
	fi
done

echo -e "guacd-hostname: localhost\nguacd-port:    4822\nuser-mapping:    /etc/guacamole/user-mapping.xml\nauth-provider:    net.sourceforge.guacamole.net.basic.BasicFileAuthenticationProvider\nbasic-user-mapping:    /etc/guacamole/user-mapping.xml" > /etc/guacamole/guacamole.properties

ln -s /etc/guacamole/guacamole.properties /usr/share/tomcat/.guacamole/
chmod 644 /etc/guacamole/guacamole.properties

md5=`printf '%s' "tecmint01" | md5sum | cut -c-32`
echo -e "<user-mapping>\n\t<authorize\n\t\tusername=\"tecmint\"\n\t\tpassword=\"$md5\"\n\t\tencoding=\"md5\">\n\t\t<connection name=\"RHEL 7\">\n\t\t\t<protocol>ssh</protocol>\n\t\t\t<param name=\"hostname\">10.0.2.20</param>\n\t\t\t<param name=\"port\">22</param>\n\t\t\t<param name=\"username\">gacanepa</param>\n\t\t</connection>\n\t\t<connection name=\"Linux Desktop\">\n\t\t\t<protocol>vnc</protocol>\n\t\t\t<param name=\"hostname\">10.0.2.21</param>\n\t\t\t<param name=\"port\">5900</param>\n\t\t</connection>\n\t</authorize>\n</user-mapping>" > /etc/guacamole/user-mapping.xml
chmod 600 /etc/guacamole/user-mapping.xml
chown tomcat:tomcat /etc/guacamole/user-mapping.xml

systemctl enable tomcat
systemctl start tomcat
/usr/local/sbin/guacd

