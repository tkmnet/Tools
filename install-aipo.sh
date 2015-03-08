#!/bin/sh


cd /tmp

wget -O aipo7020aja_linux64.tar.gz 'http://sourceforge.jp/frs/redir.php?m=iij&f=/aipo/60038/aipo7020aja_linux64.tar.gz'
tar xf aipo7020aja_linux64.tar.gz

cd aipo7020aja_linux64

apt-get update
apt-get -y install make gcc libreadline-dev libghc-zlib-dev libghc-pipes-zlib-dev lua-zlib-dev nmap
