#!/bin/sh

if [ $# -eq 1 ]; then
	if [ $1 = '-h' ]; then
		echo 'Usage: ./install-oracle-jdk.sh VERSION'
		exit
	fi
fi

DL_JAVA_VER=8
if [ $# -eq 1 ]; then
	DL_JAVA_VER=$1
fi

OS=`uname`
OS_MODE=`uname -m`

FILE_SUFFIX='NULL'
if [ $OS = 'Linux' -a $OS_MODE = 'x86_64' ]; then
	FILE_SUFFIX='linux-x64.tar.gz'
fi
if [ $OS = 'Linux' -a $OS_MODE = 'i386' ]; then
	FILE_SUFFIX='linux-i586.tar.gz'
fi
if [ $OS = 'Darwin' ]; then
	FILE_SUFFIX='macosx-x64.dmg'
fi

if [ $FILE_SUFFIX = 'NULL' ] ; then
	echo "[!] This script is not support this OS."
	exit
fi

if ! [ -x `which tar||echo /dev/null` -a -x `which gzip||echo /dev/null` ]; then
	echo "[!] This script repuire tar and gzip."
	exit
fi


echo 'You must accept the Oracle Binary Code License Agreement for Java SE.'
echo 'http://www.oracle.com/technetwork/java/javase/terms/license/index.html'

/bin/echo -n 'Do you accept the License? [y/N] > '
read answer
case $answer in
	y)
		sudo ls >/dev/null 2>&1
		;;
	*)
		echo "Cancelled."
		exit
		;;
esac


# WGET='wget -q'
WGET_FILE='wget -nv -O'
WGET_STDOUT='wget -q -nv -O -'
HEADER_OPTION='--no-check-certificate --no-cookies --header'
if ! [ -x `which wget||echo /dev/null` ]; then
	if [ -x `which curl||echo /dev/null` ]; then
		# WGET='curl -s -O'
		WGET_FILE='curl -o'
		WGET_STDOUT='curl -s'
		HEADER_OPTION='-L -H'
	else
		echo "[!] This script repuire wget or cURL."
		exit
	fi
fi


echo "Downloading... (JDK)"
$WGET_FILE /tmp/jdk${DL_JAVA_VER}-${FILE_SUFFIX} ${HEADER_OPTION} "Cookie: oraclelicense=accept-securebackup-cookie" `$WGET_STDOUT http://www.oracle.com/technetwork/java/javase/downloads/index.html | grep -o "\/technetwork\/java/\javase\/downloads\/jdk${DL_JAVA_VER}-downloads-[0-9]*\.html" | head -1 | xargs -I@ echo "http://www.oracle.com"@ | xargs $WGET_STDOUT 2>/dev/null | grep -o "http.*jdk-${DL_JAVA_VER}u[0-9]*-${FILE_SUFFIX}" | head -1`

DLSTAT=$?
if [ $DLSTAT -ne 0 -o ! -e "/tmp/jdk${DL_JAVA_VER}-${FILE_SUFFIX}" ]; then
	echo '[!] Download Failed.';
	rm -f /tmp/jdk${DL_JAVA_VER}-${FILE_SUFFIX}
	exit
fi


if [ $OS = 'Linux' ]; then
	echo "Downloading... (Installer)"
	$WGET_FILE /tmp/expand-oracle-jdk.sh https://raw.githubusercontent.com/tkmnet/Tools/master/expand-oracle-jdk.sh

	DLSTAT=$?
	if [ $DLSTAT -ne 0 -o ! -e "/tmp/expand-oracle-jdk.sh" ]; then
		echo '[!] Download Failed.';
		rm -f /tmp/expand-oracle-jdk.sh
		exit
	fi
	echo 'Installing...'
	sudo sh /tmp/expand-oracle-jdk.sh /tmp/jdk${DL_JAVA_VER}-${FILE_SUFFIX}
	rm -f /tmp/expand-oracle-jdk.sh
	rm -f /tmp/jdk${DL_JAVA_VER}-${FILE_SUFFIX}
fi

if [ $OS = 'Darwin' ]; then
	hdiutil detach /Volumes/JDK* >/dev/null 2>&1
	hdiutil attach /tmp/jdk${DL_JAVA_VER}-${FILE_SUFFIX} >/dev/null 2>&1
	echo 'Installing...'
	find /Volumes/JDK* -type f -name 'JDK*.pkg' 2>/dev/null | sed -E 's/ /\\ /g' | xargs open -W
	hdiutil detach /Volumes/JDK* >/dev/null 2>&1
	rm -f /tmp/jdk${DL_JAVA_VER}-${FILE_SUFFIX}
fi


sleep 1
if [ `javac -version 2>&1 | grep -o "javac 1.${DL_JAVA_VER}.*" | wc -l` != 1 ]; then
	echo "[!] Install Failed."
	exit
else
	java -version
	echo 'Done.'
fi

