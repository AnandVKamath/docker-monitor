#!/bin/bash
# Shell Script to monitor Docker Containers on Linux Servers
# This Shell script will check number of docker containers in server, check load and memory usage of each containers.
# Result can be emailed if docker containers exceeds certain threshold 
clear

# Inital Variable setttings
server=$(hostname)
########  Set Threshold Load Average,  change accordingly
max_load_usage=50   
########  Set Threshold Memeory Utilization, change accordingly 
max_mem_usage=50 

# Email-id      ########## Change to valid mail id ##############
mail_id=test@gmail.com

# Log File Path
stats_logfile=/tmp/dockerstatus.log
process_log=/tmp/dockerprocess.log
exited_log=/tmp/exited.log
mail_log=/tmp/mail.log

# Remove old logs files if exists

        if [ -f $stats_logfile -o -f $process_log -o -f $exited_log -o -f $mail_log ]
        then
		`rm -f $stats_logfile $exited_log $process_log $mail_log`
        fi

# Write running docker containers id and name to log file
`docker ps  |grep -v CONTAINER |awk '{print $1 "\t" $2}' >> $process_log`

# Write Status docker containers id, Load average, Memory Usage to log file
`docker stats --no-stream |grep -v CONTAINER | awk '{print $1 "\t" $2 "\t" $6 }' >> $stats_logfile`

# Get Number of running containers 
run_count=`cat $stats_logfile |wc -l`

echo  "Running Containers and Status" | tee -a $mail_log
echo  "$run_count countainers are running in the $server" | tee -a $mail_log
echo "" | tee -a $mail_log

# Print Running containers
cat $process_log |awk '{print $2}' | tee -a $mail_log

# Check if Load average and Memory usage is more than Threshold for each running containers
echo "" | tee -a $mail_log

for i in `cat $stats_logfile |awk '{print $1}'`
 do
        container=`cat $process_log |grep $i |awk '{print $2}'`
	load_useage=`cat $stats_logfile |grep $i |awk '{print int($2)}'`

	 if [ "$load_useage" -gt  "$max_load_usage" ] ; then
		echo "CPU Load on the $container is $load_useage. Higher than expected" | tee -a $mail_log
	  fi
	
	mem_usage=`cat $stats_logfile |grep $i |awk '{print int($3)}'`
	   if [ "$mem_usage" -gt "$max_mem_usage" ] ; then
		echo "Memeory on the $container is $mem_usage. Higher than expected" | tee -a $mail_log
	   fi
 done
echo "" | tee -a $mail_log

# Listed stopped / exited containers.
`docker ps -a |grep Exited | awk '{print $2}' >> $exited_log`
exited_count=`cat $exited_log |wc -l`

	if [ "$exited_count" -gt 0 ] ; then
		 echo "Exited Containers : $exited_count" | tee -a $mail_log
	         cat $exited_log | tee -a $mail_log
	else 
		echo "No Exited Containers" | tee -a $mail_log
        fi

# Mail log file to specifed mail id
mail -s "Docker Status on  $(hostname)" $mail_id < $mail_log
