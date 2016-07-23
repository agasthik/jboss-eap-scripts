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


    function StartJBOSS () {

    sudo $JBOSS_HOME/bin/core_jboss_start.sh

    }

    function Check_User (){

    local -r _User=`echo $USER`

        case "$_User" in
              root)
                    #CECHO GREEN "The $_User user account is allowed to execute the $_ScriptName script"
                    StartJBOSS
                    ;;
              webuser)
                    #CECHO GREEN "The $_User user account is allowed to execute the $_ScriptName script"
                    StartJBOSS
                    ;;
              devuser)
                    #CECHO GREEN "The $_User user account is allowed to execute the $_ScriptName script"
                    StartJBOSS
                    ;;
              *)
                    CECHO RED "The $_User user account is not allowed to execute the $_ScriptName script"
                    ;;
            esac

    }

    function main (){

		#Source the /etc/rc.d/init.d/functions
		. /etc/rc.d/init.d/functions

    # Source the JBOSS Environment Variables
    . /opt/www/appserver/jboss/bin/jboss-env.sh

    declare -r _ScriptName=`basename $0`

    Check_User

    }

    main "$@"
