#!/bin/sh

cd /usr/local
sudo cat /dev/null

# if ! [ -x `which java||echo @` ]; then
# 	echo "[!] This script repuire java."
# 	cd /tmp
# 	wget https://raw.githubusercontent.com/tkmnet/Tools/master/install-oracle-jdk.sh
# 	sh install-oracle-jdk.sh
# 	rm -f install-oracle-jdk.sh
# 	sh $0
# 	exit
# fi

sudo wget -O aipo7020aja_linux64.tar.gz 'http://sourceforge.jp/frs/redir.php?m=iij&f=/aipo/60038/aipo7020aja_linux64.tar.gz'
sudo tar xzf aipo7020aja_linux64.tar.gz
sudo rm -f aipo7020aja_linux64.tar.gz
sudo tar xzf aipo7020aja_linux/aipo7020.tar.gz
sudo rm -rf aipo7020aja_linux

sudo apt-get update
sudo apt-get -y install build-essential zlib1g-dev libreadline-gplv2-dev nmap

cd /usr/local/aipo/bin
sudo sed -iE 's/^sh /bash /' installer.sh
sudo sed -iE 's%^rpm.*$%dpkg -l > ${script_path}/bin/rpmlist%' utf8/installer.sh
sudo sed -iE 's%^tmp_str.*rpmlist.*$%tmp_str="THROW"%' utf8/installer.sh
# sudo sed -iE 's%^tar.*jre_x64.*$%ln -s /usr/lib/jvm/java-8-oracle/jre /usr/local/aipo/jre%' utf8/installer.sh

sudo sh installer.sh

