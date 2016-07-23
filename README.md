This repository contains a set of custom developed scripts to start / stop JBOSS EAP application server on a *NIX box

The script descriptions are below. The scripts would work only against a pre-installed JBOSS instance.
They need to be place inside the <JBOSS_HOME>/bin directory

<pre>
1. jboss-env.sh - Custom script to export Environment Variables and Aliases. Modify this script per your environment.
2. jboss-stop.sh - Wrapper Script to Stop the Running JBOSS service.
3. jboss-start.sh - Wrapper Script to Start the Running JBOSS service.
4. core-jboss-start.sh - This script is enables starting the JBOSS account with a specific user account. If multiple developers use the same server, you can also restict the user accounts which can start / stop the JBOSS service.

</pre>
