#!/bin/bash

yum install yum-plugin-ovl -y
yum install novnc -y
yum install xorg-x11-xinit -y
yum install tigervnc-server -y
yum install tigervnc-server-minimal -y
yum install xterm -y
yum install xfce4-panel -y
yum install xfwm4 -y

rm -f /usr/local/bin/tigervnc.sh
exec 3<> /usr/local/bin/tigervnc.sh

echo -e "#!/bin/bash\n" >&3
echo "export DISPLAY=$HOSTNAME:0" >&3
echo "export XFCE_PANEL_MIGRATE_DEFAULT=1" >&3
echo "/usr/bin/novnc_server --vnc localhost:5901 --listen 6901 &" >&3
echo "xinit -- /usr/bin/Xvnc :0 -auth /root/.Xauthority -depth 24 -desktop $HOSTNAME:0 -fp /usr/share/fonts/X11//misc,/usr/share/fonts/X11//Type1 -geometry 1280x1024 -pn -SecurityTypes=none -rfbport 5901 -rfbwait 30000 -NeverShared &" >&3
echo "/usr/bin/xfce4-panel &" >&3
echo "/usr/bin/xfwm4 &" >&3
echo "/usr/bin/xterm" >&3
echo "/bin/bash" >&3

exec 3>&-

chmod 755 /usr/local/bin/tigervnc.sh
