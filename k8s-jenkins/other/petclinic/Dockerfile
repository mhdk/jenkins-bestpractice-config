FROM jenkins/inbound-agent:alpine

# Install Maven
USER root

RUN apk add --no-cache curl tar bash

ARG MAVEN_VERSION=3.6.3

# Set the maven home variable and add it to path.
ENV MAVEN_HOME=/usr/share/maven
ENV PATH=$PATH:$MAVEN_HOME/bin

RUN mkdir -p $MAVEN_HOME && \
curl -fsSL http://apache.osuosl.org/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz \
| tar -xzC $MAVEN_HOME --strip-components=1 && \
ln -s $MAVEN_HOME/mvn /usr/bin/mvn

ENV JENKINS_HOME=/home/jenkins
ENV JENKINS_MAVEN_HOME=$JENKINS_HOME/.m2
ENV MAVEN_REPO=$JENKINS_MAVEN_HOME/repository

RUN mkdir -p $MAVEN_REPO && \
    head -n -1 $MAVEN_HOME/conf/settings.xml > temp.txt && \
    mv temp.txt $MAVEN_HOME/conf/settings.xml && \
    echo '  <localRepository>/${MAVEN_REPO}</localRepository>' \
    >> $MAVEN_HOME/conf/settings.xml && \
    echo '</settings>' >> $MAVEN_HOME/conf/settings.xml 

# speed up Maven JVM a bit
ENV MAVEN_OPTS="-XX:+TieredCompilation -XX:TieredStopAtLevel=1"

# Install project dependencies and keep sources
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# install maven dependency packages (keep in image)
COPY jgsu-spring-petclinic/pom.xml /usr/src/app
RUN mvn dependency:go-offline 

RUN chown -R jenkins $MAVEN_REPO 
RUN chown -R jenkins $MAVEN_HOME

USER jenkins