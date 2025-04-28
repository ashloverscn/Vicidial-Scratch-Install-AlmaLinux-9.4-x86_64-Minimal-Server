#!/bin/sh
#ver=3.1.0
#oem=1
ver=3.4.0
oem=0

echo -e "\e[0;32m Install Dahdi Audio_CODEC Driver v$ver \e[0m"
sleep 2
cd /usr/src
yum install kernel-devel-$(uname -r) -y
#rm -rf dahdi-linux-complete*
yum remove dahdi* -y
yum remove dahdi-tools* -y
#yum install dahdi* -y
#yum install dahdi-tools* -y
if [ $oem -eq 1 ]
then
	#wget http://download.vicidial.com/required-apps/dahdi-linux-complete-2.3.0.1+2.3.0.tar.gz
	tar -xvzf dahdi-linux-complete-2.3.0.1+2.3.0.tar.gz
	cd dahdi-linux-complete-2.3.0.1+2.3.0
else
	#wget -O dahdi-linux-complete-$ver+$ver.tar.gz https://downloads.asterisk.org/pub/telephony/dahdi-linux-complete/dahdi-linux-complete-$ver+$ver.tar.gz
	tar -xvzf dahdi-linux-complete-$ver+$ver.tar.gz
	cd dahdi-linux-complete-$ver+$ver
fi

#sed -i 's|(netdev, \&wc->napi, \&wctc4xxp_poll, 64);|(netdev, \&wc->napi, \&wctc4xxp_poll);|g' /usr/src/dahdi-linux-complete-$ver+$ver/linux/drivers/dahdi/wctc4xxp/base.c
sudo sed -i 's|, 64);|);|g' /usr/src/dahdi-linux-complete-$ver+$ver/linux/drivers/dahdi/wctc4xxp/base.c
sed -i 's|<linux/pci-aspm.h>|<linux/pci.h>|g' /usr/src/dahdi-linux-complete-$ver+$ver/linux/include/dahdi/kernel.h

#this is a temporary fix for dahdi-3.4.0 by nox
ln -sf /usr/lib/modules/$(uname -r)/vmlinux.xz /boot/
mkdir /etc/include
cd /etc/include
wget https://dialer.one/newt.h

cd /usr/src/
mkdir dahdi-linux-complete-3.4.0+3.4.0
cd dahdi-linux-complete-3.4.0+3.4.0
wget https://cybur-dial.com/dahdi-9.5-fix.zip
unzip dahdi-9.5-fix.zip
yum in newt* -y
#

#: ${JOBS:=$(( $(nproc) + $(nproc) / 2 ))}
: ${JOBS:=$(nproc)}
make -j ${JOBS} all
make install
make config
make install-config
yum -y install dahdi-tools-libs
modprobe dahdi
modprobe dahdi_dummy
dahdi_genconf -v
dahdi_cfg -v

cd tools
make clean
make -j ${JOBS} all
make install
make install-config

cd /etc/dahdi
\cp -r system.conf system.conf.bak
\cp -r system.conf.sample system.conf

echo -e "\e[0;32m Enable dahdi.service in systemctl \e[0m"
sleep 2

\cp -r /etc/systemd/system/dahdi.service /etc/systemd/system/dahdi.service.bak
rm -rf /etc/systemd/system/dahdi.service
touch /etc/systemd/system/dahdi.service

cat <<DAHDI>> /etc/systemd/system/dahdi.service

[Unit]
Description=DAHDI Telephony Drivers
After=network.target
Before=asterisk.service

[Service]
Type=oneshot
ExecStartPre=/sbin/modprobe dahdi
ExecStartPre=/sbin/modprobe dahdi_dummy
ExecStart=/usr/sbin/dahdi_cfg -v
ExecReload=/usr/sbin/dahdi_cfg -v
ExecStop=/usr/sbin/dahdi_cfg -v
Restart=on-failure
RestartSec=2
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target

DAHDI

#restart dahdi Service
systemctl daemon-reload && \
systemctl disable dahdi.service && \
systemctl enable dahdi.service && \
systemctl restart dahdi.service && \
systemctl status dahdi.service | head -n 18

