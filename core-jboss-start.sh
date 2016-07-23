#!/bin/bash

#*******************************************************************************************************
#  Author              : Agasthi Kothurkar
#
#  Version             : 1.0
#
#  Changes Done        :  Changes required to ensure that JBOSS service starts with webuser account
#                         instead of root. Additionally the /opt/www/apps/deploy director permission is
#                         set to 775 such that both webuser and devuser accounts have write permissions
#                         on that directory
#
#  Description       : This script is used to start the JBOSS 6.2 EAP Service. It has been tested on OEL 6.5
#
#  Notes                 :
#
#  Version History
#  1.0 (08-21-2014) - Initial Version
#*******************************************************************************************************

#Make the script exit when a command fails.
#set -e


#Source the /etc/rc.d/init.d/functions
. /etc/rc.d/init.d/functions

# Source the JBOSS Environment Variables
. /opt/www/appserver/jboss/bin/jboss-env.sh

# FUNCTION TO DISPLAY CUSTOM MESSAGES IN DIFFERENT COLOURS #
CECHO () {
  ARG1=$1
  ARG2=$2

case "$1" in
          RED)
                echo -e "\E[31m$2 \E[0m"
                ;;
          GREEN)
                echo -e "\E[32m$2 \E[0m"
                ;;
          YELLOW)
                echo -e "\E[33m$2 \E[0m"
                ;;
          *)
                echo -e "\E[33m$2 \E[0m"
                ;;
        esac
}

# Get the System Information
INSTANCE=`hostname`-JBOSS
INSTANCE_IP=`hostname -i`

#Environment Constant Variables
JBA_DEPLOY_DIR=/opt/www/apps/deploy
JBOSS_START_CMD="$JBOSS_HOME/bin/standalone.sh -b $INSTANCE_IP -bmanagement $INSTANCE_IP"
JBOSS_USER=webuser

#Permission is set to 775 for the JBA_DEPLOY_DIR to enable both devuser and webuser accounts to write to the $JBA_DEPLOY_DIR
#As a pre-requisite webuser account needs to be added to the devuser group in the DEV and QA Environment
JBA_DEPLOY_DIR_PERM_SET="sudo chmod 775 $JBA_DEPLOY_DIR"

	INSTANCE_RUNNING=`ps -ef | grep jboss | grep java | grep -v grep |wc -l`

	if [[ $INSTANCE_RUNNING -ne 0 ]];then
		CECHO RED "AN INSTANCE OF $INSTANCE IS ALREADY RUNNING"
		CECHO YELLOW "Please stop existing $INSTANCE and then try to start again"
		exit
		else

		CECHO GREEN "Starting the jboss service on the server `hostname`"

					if [[ "$USER" == "$JBOSS_USER" ]]
						then
							#Check if the custom deploy directory [JBA_DEPLOY_DIR] is writeable for $JBOSS_USER. If not make it writable for $JBOSS_USER
							if [[ -w $JBA_DEPLOY_DIR ]]
								then
										echo "$JBA_DEPLOY_DIR is writeable for $JBOSS_USER"
								else
										$JBA_DEPLOY_DIR_PERM_SET
							fi
							daemon $JBOSS_START_CMD &>/dev/null &
						else
							daemon --user=$JBOSS_USER $JBA_DEPLOY_DIR_PERM_SET
							daemon --user=$JBOSS_USER $JBOSS_START_CMD &>/dev/null &
					fi

					 		if [ $? -eq 0 ]; then

											#JBOSS has started. Allow it to start
											CECHO GREEN "Start command issued. Waiting 10 seconds for the jboss service to start"
											while true;do echo -n .;sleep 1;done &
								      sleep 10
								      kill $!; trap 'kill $!' SIGTERM
											#CHECK IF JBOSS HAS STARTED CORRECTLY.
											JBOSS_PROCESS_RUNNING=`ps -ef | grep jboss | grep java | grep -v grep |wc -l`

												if [[ $JBOSS_PROCESS_RUNNING -ne 0 ]]; then
												JBOSS_PID=`ps -ef | grep jboss | grep java | grep -v grep | awk ' { print $2 } '`
												CECHO GREEN "\nThe jboss service on the server started successfully. Check the $AS_LOG/server.log file for additional details"
												else
												CECHO RED "\nThe jboss service on the server failed to start"
												fi
							else
											CECHO RED "\nThe jboss service on the server failed to start"
											exit 1
							fi

	fi

exit 0
