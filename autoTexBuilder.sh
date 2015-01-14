#!/bin/bash
# REQUIRE:inotify-tools

WORKDIR=`pwd -P`
cd $WORKDIR

if ! [ -x ./build.sh ]; then
	echo "[!] Not exist executable './build.sh'."
	exit
fi

rm ACTIVATED_FAIL_SECURE
mkdir /tmp/atb.$$.tmp
cp ./build.sh /tmp/atb.$$.tmp/
cp ./*.tex /tmp/atb.$$.tmp/

while inotifywait $WORKDIR; do
	if [ `diff ./build.sh /tmp/atb.$$.tmp/build.sh | wc -l` != 0 ]; then
		echo '[!] Fail-secure stopping was activated.'
		touch ACTIVATED_FAIL_SECURE
		break
	fi
	MFILES=`diff -q ./ /tmp/atb.$$.tmp/ | sed -E 's/Files \.\///g' | sed -E 's/ and .*$//g' | sed -E 's/^.*: //g' | sed -n '/\.tex$/p'`
	UPDATEFLAG=0
	for file in $MFILES ; do
		UPDATEFLAG=1
		echo $file
		rm /tmp/atb.$$.tmp/$file
		cp $file /tmp/atb.$$.tmp/
	done
	if [ $UPDATEFLAG != 0 ]; then
		echo '! BUILD'
		./build.sh
	fi
done

rm -rf /tmp/atb.$$.tmp/

