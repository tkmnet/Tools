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
	MFILES=`diff -q ./ /tmp/atb.$$.tmp | sed -E 's/Files \.\///g' | sed -E 's/ and .*$//g' | sed -E 's/^.*: //g' | sed -n '/\.tex$/p'`
	UPDATEFLAG=0
	for file in $MFILES ; do
		echo "UPDATED: $file"
		if [ -d /tmp/atb.$$.tmp/$file ]; then
			rm -rf /tmp/atb.$$.tmp/$file
		else
			rm /tmp/atb.$$.tmp/$file
		fi
		if [ -d $file ]; then
			cp -r $file /tmp/atb.$$.tmp/
		else
			UPDATEFLAG=1
			cp $file /tmp/atb.$$.tmp/
		fi
	done
	if [ $UPDATEFLAG != 0 ]; then
		echo '! BUILD'
		./build.sh
	fi
done

rm -rf /tmp/atb.$$.tmp/

