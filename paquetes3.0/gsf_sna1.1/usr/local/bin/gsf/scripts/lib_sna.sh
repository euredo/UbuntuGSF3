#!/bin/bash
############################################
# Asistente para configurar Terminal de Impresión
# Modificado: 2020-08
############################################

MANEJARPR3287="/usr/local/bin/gsf/scripts/manejar_pr3287.sh"
LANZADORPW3270="/usr/share/mate/applications/sie.desktop"
CONFSNA="/usr/local/bin/gsf/scripts/lib_sna.sh"
LU_VIDEO_ORI="XXXXXXXX"
LU_PRINTER_ORI="XXXXXXXX"
IP_SNA_ORI="10.1.4.11"
FORMLU=0

# ************************* form_sna() Muestra el Formulario con los parámetros de Terminal Lógica a configurar ***********************************
function form_sna(){
	RESULTADOS_LU=$(yad --image=$ICONO  --window-icon=$ICONO --image-on-top  \
			--title="$TITULO_SCRIPT - $VERSION" --width=570  \
			--text="\n  Configuración de Unidades Lógicas de SNA \n \n <b>Ingrese los campos correspondientes</b>\n \n "  \
			--form --center  \
			--field="  Unidad Lógica de Video (LU):" "$LU_VIDEO_ORI"  \
			--field="  Unidad Lógica de Impresión (LU):" "$LU_PRINTER_ORI"  \
			--field="  Servidor SNA:" "$IP_SNA_ORI"  \
			--button="Siguiente:0" --button="gtk-cancel:1")

	validar_form 

	LU_VIDEO=$(echo $RESULTADOS_LU | awk 'BEGIN {FS="|" } { print $1 }')
	LU_PRINTER=$(echo $RESULTADOS_LU | awk 'BEGIN {FS="|" } { print $2 }')
	IP_SNA=$(echo $RESULTADOS_LU | awk 'BEGIN {FS="|" } { print $3 }')

	if [ -z $IP_SNA ]; 
	 then
	   mostrarYAD "Error" "Como mínimo debe ingresar <b>Servidor SNA</b>. Ingrese los datos nuevamente" "gtk-ok" 
	 else
	  FORMLU=1 
	  REP_CADENA="$REP_CADENA\n     * Se configuran las conexiones SNA con los siguientes valores:\n          -Unidad Lógica de Video (LU): <b>$LU_VIDEO</b>\n          -Unidad Lógica de Impresión (LU): <b>$LU_PRINTER</b>\n          - Servidor SNA: <b>$IP_SNA</b>"   
      Ejec+=('cambiar_SNA') 
	fi
}
# ************************* cheq_PW3240() chequea que los paquetes del emulador pw3270 esten instalados ***********************************
function cheq_PW3240(){
#  Chequeo que los paquetes se encuentren instalados
if [ echo $(apt -qq list lib3270) >/dev/null 2>&1 ]; then  
    INST_LIB= true  
    REP_CADENA="$REP_CADENA     * Se instalaran el/los siguiente/s paquete/s faltante/s:\n          -lib3270_5.1-0_amd64.deb \n"      
fi

if [ echo $(apt -qq list pw3270) >/dev/null 2>&1 ]; then  
    INST_PW3270= true 
    REP_CADENA="$REP_CADENA          -pw3270_5.1-0_amd64.deb \n"   
fi

if [ echo $(apt -qq list pw3270-plugin-dbus) >/dev/null 2>&1 ]; then 
    INST_PLUG= true 
    REP_CADENA="$REP_CADENA          -pw3270-plugin-dbus_5.1-0_amd64.deb \n"   
fi
}


# ************************* cambiar_SNA() Muestra el reporte de los cambios a realizar ***********************************
function cambiar_SNA(){

    if [ $INST_LIB -o $INST_PW3270 -o $INST_PLUG ]; then 
      sudo apt update
    fi

    if [ $INST_LIB ]; then 
      sudo  gdebi --n /usr/local/bin/gsf/debs/pw3270/lib3270_5.1-0_amd64.deb
    fi

    if [ $INST_PW3270 ]; then  
         
      sudo  gdebi --n /usr/local/bin/gsf/debs/pw3270/pw3270_5.1-0_amd64.deb
    fi

    if [ $INST_PLUG ]; then
    
     sudo  gdebi --n /usr/local/bin/gsf/debs/pw3270/pw3270-plugin-dbus_5.1-0_amd64.deb
    fi
	if [ -z $LU_VIDEO ]; 
	 then
		reemplazar Exec "pw3270 -h $IP_SNA -s $LU_VIDEO" $LANZADORPW3270 
	 else
		reemplazar Exec "pw3270 -h $IP_SNA -s $LU_VIDEO" $LANZADORPW3270 
	fi
	reemplazar LU_VIDEO_ORI "\"$LU_VIDEO\"" $CONFSNA 
	reemplazar LU_PRINTER_ORI "\"$LU_PRINTER\"" $CONFSNA 
	reemplazar IP_SNA_ORI "\"$IP_SNA\"" $CONFSNA 
	reemplazar LU_PRINTER "\"$LU_PRINTER\"" $MANEJARPR3287 
	reemplazar IP_SNA "\"$IP_SNA\"" $MANEJARPR3287 
}
# ************************* conf_SNA() Muestra el reporte de los cambios a realizar ***********************************
function conf_SNA(){
  while [ $FORMLU -eq 0 ]
  do
     form_sna
  done
}

