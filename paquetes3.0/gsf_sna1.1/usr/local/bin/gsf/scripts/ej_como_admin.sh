#!/bin/bash
echo $1
if [ -f $1 ]; then
  #script="/usr/local/bin/gsf/scripts/configurar_sna.sh"
  #echo "ejecuta el script" $script
  Exec= pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY DBUS_SESSION_BUS_ADDRESS=$DBUS_SESSION_BUS_ADDRESS bash $(echo $1)

fi


