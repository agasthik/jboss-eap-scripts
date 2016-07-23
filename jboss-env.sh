#All the environment variables required by the application servers and code to execute

JBOSS_HOME=/opt/www/appserver/jboss
JAVA_HOME=/opt/www/java/jdk
PATH=$JAVA_HOME/bin:$PATH

export JBOSS_HOME JAVA_HOME PATH

#Aliases defined for effective server start / stop tasks
alias jboss_check='ps -ef | grep java | grep jboss | grep -v grep'
alias jboss_stop='/opt/www/appserver/jboss/bin/jboss-stop.sh'
alias jboss_start='/opt/www/appserver/jboss/bin/jboss-start.sh'
