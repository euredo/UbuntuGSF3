#!/bin/bash
echo "Configurando entorno wine..."
#	Crear el grupo wine 
	sudo addgroup wine

#	Agregar al usuario aplicaciones al grupo wine
        adduser --system  --ingroup "wine" aplicaciones
#	Permitir la ejecución de las aplicaciones al usuario administrador y al grupo users
    echo "administrador ALL=(aplicaciones) NOPASSWD: ALL" > /tmp/wine
    echo "%users ALL=(aplicaciones) NOPASSWD: ALL" >> /tmp/wine
    echo "%users ALL=(xhost) NOPASSWD: ALL" >> /tmp/wine
	sudo cp /tmp/wine /etc/sudoers.d/wine
	chmod 440 /etc/sudoers.d/wine
	sudo rm /tmp/wine

#	Evitar que los otros usuarios utilicen wine
	sudo chown root:wine /usr/bin/wine*
	sudo chmod o-x /usr/bin/wine*
        #sudo usermod -a -G wine administrador

# Agrego a todos los usuarios al grupo users y solo a los administradores al grupo wine
declare -a array_usuarios
declare -a array_grupos
i=0
while read linea
do
   array_usuarios[$i]="$linea"
   echo "Usuario " ${array_usuarios[$i]}
   sudo usermod -a -G users ${array_usuarios[$i]}
   grupos= echo $(groups ${array_usuarios[$i]}) > /dev/null
# Recorro los grupos si encuentra al grupo "adm" suma el grupo "wine"
   IFS=' ' read -a array_grupos <<< $(echo $(groups ${array_usuarios[$i]}))
   len=${#array_grupos[@]}
   for (( ii=0; ii<$len; ii++ )); do 
       if [ ${array_grupos[$ii]} == "adm" ];
       then 
         echo "Es administrador e ingresa a grupo wine"
         sudo usermod -a -G wine ${array_usuarios[$i]}
         id ${array_usuarios[$i]}
       fi
   done
((i++))
done  <<< "$(eval getent passwd {$(awk '/^UID_MIN/ {print $2}' /etc/login.defs)..$(awk '/^UID_MAX/ {print $2}' /etc/login.defs)} | cut -d: -f1)"

