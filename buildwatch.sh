#!/bin/bash
# REQUIRE:inotify-tools

WORKDIR=~/Dropbox/AIT_Rescue/ADK_TeX
WATCHING_FILE=~/Dropbox/AIT_Rescue/ADK_TeX/*.tex
EVENT=CREATE,MOVE_SELF
WAIT=3

cd $WORKDIR
cp ./build.sh /tmp/build.sh.$$.tmp

while inotifywait -e $EVENT $WATCHING_FILE; do
	diff ./build.sh /tmp/build.sh.$$.tmp | wc -l
	if [ `diff ./build.sh /tmp/build.sh.$$.tmp | wc -l` != 0 ]; then
		echo '[!] Fail-secure is operated.'
		exit
	fi
	sleep $WAIT
	./build.sh
done

rm /tmp/build.sh.$$.tmp

