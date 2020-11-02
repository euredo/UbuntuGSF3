#!/bin/bash
############################################
# Asistente para configurar Terminal de Impresión
# Modificado: 2020-08
############################################


ARCH3270="/usr/local/bin/gsf/config/SIE.3270"
MANEJARPR3287="/usr/local/bin/gsf/scripts/manejar_pr3287.sh"
LANZADORPW3270="/usr/share/applications/sie.desktop"
CONFSNA="/usr/local/bin/gsf/scripts/lib_sna.sh"
LU_VIDEO_ORI="XXXXXXXX"
LU_PRINTER_ORI="XXXXXXXX"
IP_SNA_ORI="10.1.4.11"
FORMLU=0
INST_PW3270="TRUE"


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

    REP_CADENA_Inst="$REP_CADENA_Inst          -lib3270_5.3+git20201024-0+39.1_amd64.deb \n"      

    REP_CADENA_Inst="$REP_CADENA_Inst          -libv3270_5.3+git20200915-0+311.2_amd64.deb \n"      

    REP_CADENA_Inst="$REP_CADENA_Inst          -pw3270_5.3+git20200820-0+40.4_amd64.deb \n"   

    REP_CADENA_Inst="$REP_CADENA_Inst          -pw3270-keypads_5.3+git20200820-0+40.4_amd64.deb \n"   

# si falta algun paquete se agrega la cadena de confirmacion de instalaciones a la cadena de confirmacion de cambios
echo "INST_PW3270: $INST_PW3270"
INST=$INST_PW3270
echo "inst: "$INST
if [[ $INST = "TRUE" ]]; then
   REP_CADENA="$REP_CADENA\n \n    * Se instalaran el/los siguiente/s paquete/s faltante/s:\n$REP_CADENA_Inst        <b>La instalación de dichos paquetes se hace una sola vez y puede demorar unos minutos. SEA PACIENTE</b>\n"
fi
}

# ************************* reemplazar claves en archivos - reemplazar $clave $valor $archivo ************
function reemplazar(){
    echo "Reemplaza el parametro $1 en el archivo $3"
	sed -i "s/\($1 *= *\).*/\1$2/" $3
}



# ************************* cambiar_SNA() Realiza los cambios ya confirmados ***********************************
function cambiar_SNA(){
# si falta algun paquete actualiza los repositorios e instala los paquetes faltantes
    if [[ $INST = "TRUE" ]];then
      sudo apt update   
      
        echo & echo & echo "gdebi --n /usr/local/bin/gsf/debs/pw3270/lib3270_5.3+git20201024-0+39.1_amd64.deb"
        sudo  gdebi --n /usr/local/bin/gsf/debs/pw3270/lib3270_5.3+git20201024-0+39.1_amd64.deb
        
        echo & echo & echo "gdebi --n /usr/local/bin/gsf/debs/pw3270/libv3270_5.3+git20200915-0+311.2_amd64.deb"
        sudo  gdebi --n /usr/local/bin/gsf/debs/pw3270/libv3270_5.3+git20200915-0+311.2_amd64.deb
      
        echo & echo & echo "gdebi --n /usr/local/bin/gsf/debs/pw3270/pw3270_5.3+git20200820-0+40.4_amd64.deb"
        sudo  gdebi --n /usr/local/bin/gsf/debs/pw3270/pw3270_5.3+git20200820-0+40.4_amd64.deb
      
       echo & echo & echo "gdebi --n /usr/local/bin/gsf/debs/pw3270/pw3270-keypads_5.3+git20200820-0+40.4_amd64.deb"  
       sudo  gdebi --n /usr/local/bin/gsf/debs/pw3270/pw3270-keypads_5.3+git20200820-0+40.4_amd64.deb
       
      
    fi
    
  # Reemplaza las variables en los archivos de configuración.  
    if [ [ -z $LU_VIDEO] ];
    then 
	    reemplazar lu-names "" $ARCH3270 
	    LU_VIDEO="XXXXXXXX"
	else
	    if [[ $LU_VIDEO = *"XXXX"* ]];
	    then 
	      reemplazar lu-names "" $ARCH3270 
	      LU_VIDEO="XXXXXXXX"
	    else
	      reemplazar lu-names "$LU_VIDEO" $ARCH3270 
	      
	    fi
	fi
	
	reemplazar url "tn3270://$IP_SNA:telnet" $ARCH3270 
	
	reemplazar Exec "pw3270 $ARCH3270 " $LANZADORPW3270
	
	reemplazar INST_PW3270 "\"false\""  $CONFSNA 
	
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

