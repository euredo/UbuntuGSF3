#!/bin/bash

if [ echo $(dpkg -l | grep -i  nano) >/dev/null 2>&1 ]; then  
    echo "No existe"
else
   echo "existe"
fi
