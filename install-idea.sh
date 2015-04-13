#!/bin/sh

sudo ls
cd /tmp
rm -rf idea
mkdir idea
cd idea
wget -O /tmp/idea/idea.tar.gz `wget -q -O - https://www.jetbrains.com/idea/download/download_thanks.jsp --post-data "os=linux&edition=IC" | grep -o "https:\/\/.*\.tar\.gz" | head -1`
tar xvf idea.tar.gz
IDEA=`find -maxdepth 1 -mindepth 1 -type d | sed -E 's%./%%g'`
echo $IDEA

#fix idea
cd ${IDEA}/bin
mv idea.sh idea.sh.org
echo '#!/bin/sh' > idea.sh
echo 'export JAVA_HOME=`which javac | xargs readlink -f | xargs dirname | xargs dirname`' >> idea.sh
cat idea.sh.org >> idea.sh
chmod a+x idea.sh

sudo mkdir -p /usr/lib/idea
sudo mv /tmp/idea/$IDEA /usr/lib/idea/
sudo update-alternatives --install "/usr/bin/idea" "idea" "/usr/lib/idea/${IDEA}/bin/idea.sh" 1
sudo update-alternatives --set idea "/usr/lib/idea/${IDEA}/bin/idea.sh"

rm -rf /tmp/idea


exit

