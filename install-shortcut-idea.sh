#!/bin/sh

cd /usr/local/bin
echo '#!/bin/sh' > idea
echo 'export JAVA_HOME=`which javac | xargs readlink -f | xargs dirname | xargs dirname`' >> idea
echo 'intellij-idea-ce-eap' >> idea
chmod a+x idea
