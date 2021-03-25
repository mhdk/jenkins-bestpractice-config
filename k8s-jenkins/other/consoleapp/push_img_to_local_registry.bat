ECHO OFF

docker build -t 192.168.0.33:31320/docker-agent-dnc:v1 - < dotnetcore.Dockerfile
docker push 192.168.0.33:31320/docker-agent-dnc:v1