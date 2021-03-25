ECHO OFF

@REM docker stop testcontainer
@REM docker rm testcontainer

@REM Couldn't use "- < mavenjdkagent.Dockerfile" as the "ADD" command
@REM wouldn't find the directory to copy from. --no-cache
docker build --no-cache -t 192.168.0.33:31320/jenkins-docker-casc:v1 .
docker push 192.168.0.33:31320/jenkins-docker-casc:v1

@REM docker run -d --name testcontainer localhost:5000/docker-agent-mavenjdk:v1

@REM docker exec -it testcontainer bash

@REM docker build --no-cache -t localhost:5000/jenkins-docker-casc:v1 .