#!/bin/sh

sudo cat /dev/null
cd /tmp
rm -rf idea
mkdir idea
cd idea
wget -O /tmp/idea/idea.tar.gz `wget -q -O - https://www.jetbrains.com/idea/download/download_thanks.jsp --post-data "os=linux&edition=IC" | grep -o "https:\/\/.*\.tar\.gz" | head -1`
tar xvf idea.tar.gz
rm -f idea.tar.gz
IDEA=`ls ./`
echo $IDEA

sudo mkdir -p /usr/lib/idea
sudo mv /tmp/idea/${IDEA} /usr/lib/idea/
sudo update-alternatives --install "/usr/bin/idea" "idea" "/usr/lib/idea/${IDEA}/bin/idea.sh" 1
sudo update-alternatives --set idea "/usr/lib/idea/${IDEA}/bin/idea.sh"


exit

