##### This repository contains a set of custom developed scripts to start / stop JBOSS EAP application server on a *NIX box




The script descriptions are below. The scripts would work only against a pre-installed JBOSS instance.
They need to be place inside the <JBOSS_HOME>/bin directory


`jboss-env.sh` - Custom script to export Environment Variables and Aliases.
Modify this script per your environment.



`jboss-stop.sh` - Wrapper Script to Stop the Running JBOSS service.


`jboss-start.sh` - Wrapper Script to Start the Running JBOSS service.


`core-jboss-start.sh` - This script is enables starting the JBOSS account with a
specific user account. If multiple developers use the same server, you can
also restrict the user accounts which can start / stop the JBOSS service.
