#!/bin/bash
# Shell Script to Clear Disk space by removing unwanted docker containers / images / volumes
# Tested in Ubuntu server 16.04 and 18.04 LTS  
clear

#Inital Variable setttings
server=$(hostname)
day=$(echo `date +"%Y-%m-%d"`)
time=$(echo `date +"%H:%M:%S"`)

# Log File Path
exited_log=/tmp/docker-exited"-"$day"-"$time".log"
image_log=/tmp/docker-image"-"$day"-"$time".log"
orphaned_log=/tmp/docker-orphaned"-"$day"-"$time".log"
dead_log=/tmp/docker-dead"-"$day"-"$time".log"

#List Exited containers
echo "Exited containers" > $exited_log
`docker ps --filter status=exited -aq >> $exited_log`
# Remove exited containers
echo "Removing exited containers" >> $exited_log
for i in `cat $exited_log`
do
echo $i
`docker ps --filter status=exited -aq | xargs -r docker rm -v`
done

#List  unused docker images
echo "Unused docker images." > $image_log
`docker images | grep "<none>" | awk -F' ' '{print $3}' >> $image_log`
# Remove unused docker images
echo "Unused docker images. Will take time depending of list of images" >> $image_log
for i in `cat $image_log`
do
echo $i
`docker rmi $(docker images | grep "<none>" | awk -F' ' '{print $3}')`
done

#List  orphaned docker volumes
echo "Orphaned docker images" > $orphaned_log
`docker volume ls -qf dangling=true >> $orphaned_log`
# Remove orphaned docker volumes
echo "Removing Unused docker images" >> $orphaned_log
for i in `cat $orphaned_log`
do
echo $i
`docker volume rm  $(docker volume ls -qf dangling=true)`	
done 

#List  orphaned docker volumes
echo "Dead docker containers" > $dead_log
`docker ps --filter status=dead -aq >> $dead_log`
# Remove dead containers
echo "Removing Dead docker containers" >> $dead_log
for i in `cat $dead_log`
do
echo $i
`docker ps --filter status=dead -aq | xargs -r docker rm -v`
done 
