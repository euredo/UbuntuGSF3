#!/bin/bash
echo "Eliminando onfigurando entorno wine..."

#	Eliminar la configuracion sudoers para el grupo wine
	sudo rm /tmp/wine /etc/sudoers.d/wine
	
#	Abilita que los otros usuarios utilicen wine
	sudo chown root:root /usr/bin/wine*
	sudo chmod o+x /usr/bin/wine*

#	Eliminar al usuario aplicaciones y asignar todos los archivos y directorios remanentes a usuario root
sudo find /user/local/bin/gsf/ -uid $(sudo cat /etc/passwd |grep aplicaciones |cut -d: -f3) -exec chown -R root {} \;
        deluser aplicaciones
        
#	Eliminar el grupo wine y asignar todos los archivos y directorios remanentes a grupo root 

sudo find /user/local/bin/gsf/ -gid $(sudo cat /etc/group | grep "wine:"| cut -d: -f3) -exec chown -R :root {} \;
	sudo delgroup wine

