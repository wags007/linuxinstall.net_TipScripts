#!/bin/bash
num_args=$(echo $#)
userhost=$1
if [ $num_args -lt "1" ]
then
    echo "Usage: $0 username@host_to_connect_to"
    echo "Missing a username and host to connect to."
else
vncviewer=$(which vncviewer.exe)
  if [ -x  "${vncviewer}" ]
  then
    ssh=$(which ssh)
    echo ${ssh}
    if [ -x ${ssh} ]
    then
     ssh ${userhost} -n -N -C -L 5900:localhost:5901 &
     sleep 1
     "${vncviewer}" -encoding hextile localhost:0
     killall ssh
    else
      echo "No ssh found.  Cannot ssh to the machine"
    fi
  else
    echo "vncviewer is either not installed or not in your path."
    echo "If you have not installed tightvnc visit http://www.tightvnc.com/ "
    echo "and install it."
  fi
fi