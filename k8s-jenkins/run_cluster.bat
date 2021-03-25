@REM kubectl -n jenkins delete deployment jenkins
kubectl delete all --all -n jenkins --grace-period 0 --force

@REM @REM Creating the namespace and specifying it in each of the following.
kubectl create namespace jenkins

kubectl -n jenkins apply -f jenkins.ingress.yaml

@REM Run the registry and push the image to it ready for the jenkins pod to pick it up.
@REM Also gives the registry service a pseudo external IP address, to which we can push
@REM our images.
kubectl -n jenkins apply -f registry.deployment.service.yaml
minikube service registry -n jenkins

@REM Build and push the jenkins master node docker image to the registry, ready for
@REM jenkins to pick it up.
docker build -t 192.168.0.33:31320/jenkins-docker-casc:v1 .
docker push 192.168.0.33:31320/jenkins-docker-casc:v1

@REM Navigating to the "other" folder, in which the docker files for the jenkins agents
@REM for the different applications are kept.
@REM Building the dot net core jenkins agent dockerfile and pushing it to the registry.
cd other/consoleapp
docker build -t 192.168.0.33:31320/docker-agent-dnc:v1 - < dotnetcore.Dockerfile
docker push 192.168.0.33:31320/docker-agent-dnc:v1
cd ..\..

@REM Building the maven jdk jenkins agent docker file and pushing it to the registry.
cd other/petclinic
docker build -t 192.168.0.33:31320/docker-agent-mavenjdk:v1 .
docker push 192.168.0.33:31320/docker-agent-mavenjdk:v1
cd ..\..

@REM Config maps and secrets that are referenced in deployment which contain the
@REM JCasC config file.
kubectl -n jenkins apply -f jenkins.configmap.yaml

@REM Creating Jenkins deployment and service.
kubectl -n jenkins apply -f jenkins.deployment.yaml
kubectl -n jenkins apply -f jenkins.service.yaml

@REM Creating Persistent volume and claim to mount the jenkins home folder
@REM onto the node filesystem.
kubectl -n jenkins apply -f jenkins.pv.yaml
kubectl -n jenkins apply -f jenkins.pvc.yaml

@REM Role binding but not sure what this does.
kubectl -n jenkins apply -f jenkins.rbac.yaml

@REM Shows all items in the jenkins namespace and gives the jenkins service a
@REM pseudo-external IP. Then listing all the services - this should show jenkins
@REM and the registry.
kubectl -n jenkins get all
minikube service jenkins -n jenkins
minikube service list -n jenkins