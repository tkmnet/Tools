#!/bin/sh


cd /usr/local
sudo cat /dev/null

sudo wget -O aipo7020aja_linux64.tar.gz 'http://sourceforge.jp/frs/redir.php?m=iij&f=/aipo/60038/aipo7020aja_linux64.tar.gz'
sudo tar xzf aipo7020aja_linux64.tar.gz
sudo rm -f aipo7020aja_linux64.tar.gz
sudo tar xzf aipo7020aja_linux/aipo7020.tar.gz
sudo rm -rf aipo7020aja_linux

# sudo apt-get update
# sudo apt-get -y install make gcc libreadline-dev libghc-zlib-dev libghc-pipes-zlib-dev lua-zlib-dev nmap

cd /usr/local/aipo/bin
sudo sh installer.sh
