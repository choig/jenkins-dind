#!/bin/sh

# give a little time for jenkins to startup
sleep 120

cd /home/jenkins-build
curl -o jenkins-cli.jar http://jenkins:8080/jnlpJars/jenkins-cli.jar
curl -o agent.jar http://jenkins:8080/jnlpJars/agent.jar

sed -i'' -e "s/NODENAME/$(hostname -s)/g" node-template.xml 
java -jar jenkins-cli.jar -s http://jenkins:8080 create-node < node-template.xml

java -jar agent.jar -jnlpUrl http://jenkins:8080/computer/$(hostname -s)/slave-agent.jnlp
