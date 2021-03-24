# "FROM" specifies the base image of jenkins.
FROM jenkins/jenkins:lts-alpine

USER root

COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

USER jenkins