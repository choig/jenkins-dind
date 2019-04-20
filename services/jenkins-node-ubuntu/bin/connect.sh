#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

set -x

##########################################################################
# TODO: jenkins agent is dying before the trap finishes
function on_exit {
    cd /home/jenkins-build
    java -jar jenkins-cli.jar -s http://jenkins:8080 delete-node $(hostname -s)
}
trap on_exit SIGTERM SIGKILL TERM KILL
##########################################################################

# give a little time for jenkins to startup
sleep 120

# get some jenkins related binaries
cd /home/jenkins-build
curl -o jenkins-cli.jar ${JENKINS_URL}/jnlpJars/jenkins-cli.jar
curl -o agent.jar ${JENKINS_URL}/jnlpJars/agent.jar

# tweak the template and register the agent
sed -i'' -e "s/NODENAME/$(hostname -s)/g" node-template.xml 
java -jar jenkins-cli.jar -s ${JENKINS_URL} create-node < node-template.xml

# time to connect
java -jar agent.jar -jnlpUrl ${JENKINS_URL}/computer/$(hostname -s)/slave-agent.jnlp
