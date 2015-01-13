#!/bin/bash
# REQUIRE:inotify-tools

WORKDIR=~/Dropbox/AIT_Rescue/ADK_TeX
WATCHING_FILE=*.tex

cd $WORKDIR
rm ACTIVATED_FAIL_SECURE
cp ./build.sh /tmp/build.sh.$$.tmp
mkdir /tmp/bw.$$.tmp
cp $WATCHING_FILE /tmp/bw.$$.tmp/

while inotifywait -r $WORKDIR; do
	NEW=0
	ls $WATCHING_FILE | xargs -I{} diff {} /tmp/bw.$$.tmp/{} || NEW=1
	if [ `diff ./build.sh /tmp/build.sh.$$.tmp | wc -l` != 0 ]; then
		echo '[!] Fail-secure stopping was activated.'
		touch ACTIVATED_FAIL_SECURE
		exit
	fi
	if [ $NEW != 0 -o `ls $WATCHING_FILE | xargs -I{} diff {} /tmp/bw.$$.tmp/{} | wc -l` != 0 ]; then
		echo '! BUILD'
		cp $WATCHING_FILE /tmp/bw.$$.tmp/
		./build.sh
	fi
done

rm /tmp/build.sh.$$.tmp
rm -rf /tmp/bw.$$.tmp/

