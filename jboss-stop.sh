#!/bin/bash

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


    function StopJBOSS (){

		local -r _Instance=`hostname`-JBOSS
		local -r _Instance_IP=`hostname -i`

    local -r _Instance_Running=`ps -ef | grep jboss | grep java | grep -v grep |wc -l`

    if [[ $_Instance_Running -eq 0 ]];then
    		CECHO RED "$_Instance Instance is not running on this server."
    		exit
    		else
    		CECHO GREEN "Invoking the shutdown process for $_Instance instance"

    		sudo $JBOSS_HOME/bin/jboss-cli.sh --connect controller=$_Instance_IP:9999  command=:shutdown &>/dev/null &

    		CECHO GREEN "Waiting 5 seconds for the jboss service to shutdown"
    		#ALLOW JBOSS TO STOP
  			while true;do echo -n .;sleep 1;done &
        sleep 5
        kill $!; trap 'kill $!' SIGTERM

    		#CHECK IF JBOSS HAS STOPPED CORRECTLY.
    		local -r _Jboss_Process_Running=`ps -ef | grep jboss | grep java | grep -v grep |wc -l`

    			if [[ $_Jboss_Process_Running -eq 0 ]]; then
    			CECHO GREEN "\nThe jboss service on the server was stopped successfully."
    			else
    			CECHO RED "\nThe $_Instance service on this server failed to stop"
    			fi

    fi

    }

    function Check_User (){

    local -r _User=`echo $USER`

        case "$_User" in
              root)
                    #CECHO GREEN "The $_User user account is allowed to execute the $_ScriptName script"
                    StopJBOSS
                    ;;
              webuser)
                    #CECHO GREEN "The $_User user account is allowed to execute the $_ScriptName script"
                    StopJBOSS
                    ;;
              devuser)
                    #CECHO GREEN "The $_User user account is allowed to execute the $_ScriptName script"
                    StopJBOSS
                    ;;
              *)
                    CECHO RED "The $_User user account is not allowed to execute the $_ScriptName script"
                    ;;
            esac

    }

    function main (){

    # Source the JBOSS Environment Variables
    . /opt/www/appserver/jboss/bin/jboss-env.sh

    declare -r _ScriptName=`basename $0`

    Check_User

    }

    main "$@"
