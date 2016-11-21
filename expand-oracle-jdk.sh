#!/bin/sh

if [ $# -eq 1 ]; then
	if [ $1 = '-h' ]; then
		echo 'Usage: ./expand-oracle-jdk.sh FILENAME'
		exit
	else
		FILENAME=$1
	fi
fi


if ! [ -e $FILENAME ]; then
	echo Failed.
	exit
fi


sudo ls >/dev/null
echo 'Expanding...'

mkdir /tmp/jdk.$$.tmp
cp $FILENAME /tmp/jdk.$$.tmp/
cd /tmp/jdk.$$.tmp
sudo tar zxf $FILENAME
JDKDIR=`find -maxdepth 1 -mindepth 1 -type d | sed -E 's%./%%g'`
sudo mkdir -p /usr/lib/jvm
sudo rm -rf /usr/lib/jvm/${JDKDIR}
sudo mv ./${JDKDIR} /usr/lib/jvm/
sudo update-alternatives --install "/usr/bin/java" "java" "/usr/lib/jvm/${JDKDIR}/jre/bin/java" 1 --slave "/usr/bin/javaws" "javaws" "/usr/lib/jvm/${JDKDIR}/jre/bin/javaws" --slave "/usr/bin/ControlPanel" "ControlPanel" "/usr/lib/jvm/${JDKDIR}/jre/bin/ControlPanel" --slave "/usr/bin/javac" "javac" "/usr/lib/jvm/${JDKDIR}/bin/javac" --slave "/usr/bin/jar" "jar" "/usr/lib/jvm/${JDKDIR}/bin/jar" --slave "/usr/bin/jdeps" "jdeps" "/usr/lib/jvm/${JDKDIR}/bin/jdeps"
sudo update-alternatives --set java "/usr/lib/jvm/${JDKDIR}/jre/bin/java"
sudo rm -rf /tmp/jdk.$$.tmp


