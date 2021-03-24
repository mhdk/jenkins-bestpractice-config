# docker build -t agent-dnc:v1 - < dotnetcore.Dockerfile
#
# docker login
# docker build -t whaywardstfc/jenkins-test/docker-agent-dnc:v1 - < dotnetcore.Dockerfile
# docker push whaywardstfc/jenkins-test/docker-agent-dnc:v1
#
FROM jenkins/inbound-agent:latest
USER root

# We are triggering the linux package tool and first updating our list of packages.
# Then we execute the install command to update installed packages.
#
# Here we are requesting Microsoft's Public Key ("microsoft.asc").
# We are piping that key in to "gpg"
# Then we move this to the /etc/apt/ 'trusted' directory.
# Then we issue shell commands to create a file in etc "/etc/apt/sources.list.d/"
# that will have the contents of the echo.
# This is all registering a microsoft package feed with the apt.
RUN apt-get update && apt-get install -y --no-install-recommends \    
    curl libunwind8 gettext apt-transport-https && \   
    curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg && \  
    mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg && \
    sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-debian-stretch-prod stretch main" > /etc/apt/sources.list.d/dotnetdev.list' && \
    apt-get update

# Now we call apt-get to install the dotNet SDK and add the install location
# to the path.
# echo out the version to the docker console.
RUN apt-get install -y dotnet-sdk-3.1 && \
    export PATH=$PATH:$HOME/dotnet && \
    dotnet --version

USER jenkins