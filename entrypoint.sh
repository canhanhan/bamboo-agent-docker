#!/bin/bash -l
set -x 

if [ -f /etc/ssl/certs/publickey.pem ]; then
  keytool -import -trustcacerts -alias publickey -file /etc/ssl/certs/publickey.pem -keystore ${JAVA_HOME}/lib/security/cacerts -storepass changeit -noprompt
fi

exec "$@"
