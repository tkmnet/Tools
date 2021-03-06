#!/bin/sh

cd /usr/local
sudo cat /dev/null

sudo userdel -r aipo_postgres
sudo rm -rf /usr/local/aipo

sudo wget -O aipo7020aja_linux64.tar.gz 'http://sourceforge.jp/frs/redir.php?m=iij&f=/aipo/60038/aipo7020aja_linux64.tar.gz'
sudo tar xvzf aipo7020aja_linux64.tar.gz
sudo rm -f aipo7020aja_linux64.tar.gz
sudo tar xvzf aipo7020aja_linux/aipo7020.tar.gz
sudo rm -rf aipo7020aja_linux

sudo apt-get update
sudo apt-get -y install build-essential gcc-4.7 zlib1g-dev libreadline-gplv2-dev nmap

cd /usr/local/aipo/bin
sudo sed -iE 's/^sh /bash /' installer.sh
sudo sed -iE 's%^rpm.*$%dpkg -l > ${script_path}/bin/rpmlist%' utf8/installer.sh
sudo sed -iE 's%^tmp_str.*rpmlist.*$%tmp_str="THROW"%' utf8/installer.sh

sudo sed -iE 's%gcc -m64%gcc-4.7 -m64%' utf8/installer.sh

sudo sh installer.sh


sudo sed -iE 's%/etc/sysconfig/network-scripts/ifcfg-${netitf}%/etc/network/interfaces%' startup.sh
sudo sed -iE 's%ifconfig ${netitf}%ifconfig eth0%' startup.sh

sudo wget -O /etc/init.d/aipo https://gist.githubusercontent.com/tkmnet/cb3dfd43393befb88b13/raw/05f9b148de44142d347aed007e9fc002dc1c91e7/aipo
sudo chmod +x /etc/init.d/aipo
sudo update-rc.d aipo defaults 90 9

sudo /etc/init.d/aipo stop
sudo /etc/init.d/aipo start

sudo tail -5 install.log
echo
