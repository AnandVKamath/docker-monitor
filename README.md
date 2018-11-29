Script Name : moniti-docker.sh
Shell Script to monitor Docker Containers on Linux Servers. This Shell script will check number of docker containers in server, check load and memory usage of each containers.Result can be emailed if docker containers exceeds certain threshold

Script Name : docker-diskcleanup.sh
Shell Script to Clear Disk space by removing unwanted docker containers / images / volumes


Clone

git clone https://github.com/AnandVKamath/docker-monitor.git

Setup

cd docker-monitor;
chmod +x docker-diskcleanup.sh
chmod +x moniti-containers.sh

Useage 

./docker-diskcleanup.sh

./moniti-containers.sh
 


Tested in Ubuntu server 16.04 and 18.04 LTS  
 
