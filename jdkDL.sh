#!/bin/sh

DL_JAVA_V=8
if [ $# -eq 1 ]; then
	DL_JAVA_V=$1
fi

wget -O /tmp/jdk${DL_JAVA_VER}.tar.gz --no-check-certificate --no-cookies - --header "Cookie: oraclelicense=accept-securebackup-cookie" `wget -q -O - http://www.oracle.com/technetwork/java/javase/downloads/index.html | grep -o "\/technetwork\/java/\javase\/downloads\/jdk${DL_JAVA_VER}-downloads-[0-9]*\.html" | head -1 | xargs -I@ echo "http://www.oracle.com"@ | xargs wget -q -O - | grep -o "http.*jdk-${DL_JAVA_VER}u[0-9]*-linux-x64.tar.gz" | head -1`
