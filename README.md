minecraft-server-helper
=======================

Minecraft Server Helper Tool to manage the server, backup files, and show status

Author:  Mike Rodarte (mts7777777)
Created: 2014-03-07

Thank you for downloading my files! I hope these prove useful for you with your
Minecraft server experiences. I've included useful functions in this file for 
your convenience. I'm sure this can be improved over time, but it is as good as 
I can get it for now. Please contact me if you have suggestions or comments.

Enjoy!

Instructions
====================
Copy mserver to your Minecraft serer directory. (cp mserver /usr/games/minecraft/)
Give mserver execute permissions (chmod +x mserver)
Put the 3 lines of crontab in your crontab (crontab -e)

Basic Usage
====================
Start the server: mserver start
Stop the server: mserver stop
Restart the server: mserver restart
Get server status: mserver status

Cron Usage
====================
Check server status and start the server if it is stopped: mserver check
Backup the entire Minecraft server directory: mserver bfull
Backup the Minecraft server directory, excluding defined values: mserver bquick

Details
====================
mserver creates a file named minecraft.pid when the start parameter is passed to
it. This file is used for checking server status. 

Restart checks to see if the server is stopped or not, and if it is not, then 
restart will stop the server. Start will check to see if the server is started 
and will start the server if it is stopped.
