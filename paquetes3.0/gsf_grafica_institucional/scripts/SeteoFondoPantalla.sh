#!/bin/bash
############################################
# Seteo de fondo de pantalla por defecto para el sistema
# Modificado: 2020-05
############################################
#clear


INICIO=1
DATE=$(date)
LOG="$DATE    $0 reemplaza fondo de pantalla por defecto para el sistema"
#if  [ $1 ];
#then
#  echo"   /n No se recibio fondo como argumento se emplea fondo por defecto"
  FONDO_PANTALLA_GSF="/usr/share/backgrounds/gsf/wallpaperGSF-1920x1080.png"
#fi
#if  [ $2 ];
#then
#  echo"  /n No se recibio esquema como argumento se emplea esquema por defecto"
  ARCHIVO_FSCHEMA=/usr/share/glib-2.0/schemas/20_mate-ubuntu.gschema.override
#fi

if [ -f $ARCHIVO_FSCHEMA ];
then 
   FONDO_PANTALLA_ORI=$(cat $ARCHIVO_FSCHEMA | grep picture-filename | awk 'BEGIN {FS="=" } { print $2 }') # Extrae el fondo de pantalla por defecto en el esquema.
   LONG=$((${#FONDO_PANTALLA_ORI} - 2)) 
   FONDO_PANTALLA_ORI=${FONDO_PANTALLA_ORI:${INICIO}:${LONG}} # Quita los apostrofos 
   if [ -f $FONDO_PANTALLA_GSF ];
   then

      sed -i -e "s!$FONDO_PANTALLA_ORI!$FONDO_PANTALLA_GSF!" $ARCHIVO_FSCHEMA
      if [ $? = 0 ] ;
      then
          LOG="$LOG  \n Archivo Modificado=$ARCHIVO_FSCHEMA \n Walpaper_Original=$FONDO_PANTALLA_ORI \n Walpaper_Nuevo=$FONDO_PANTALLA_GSF\n "
      fi
   else 
      LOG="$LOG  /n No se encontró el archivo $FONDO_PANTALLA_GSF"
   fi 
else

   LOG="$LOG /n No se encontró el archivo $ARCHIVO_FSCHEMA"
fi
## Compilar esquemas
sudo glib-compile-schemas /usr/share/glib-2.0/schemas/ &>/dev/null
LOG="$LOG /n Esquemas Compilados"
   echo -e $LOG >> GSF.log
