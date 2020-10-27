#!/bin/bash
############################################
# Asistente para configurar Terminales SNA 
# de video y de Impresión
# Modificado: 2020-08
############################################


source /usr/local/bin/gsf/scripts/lib_sna.sh 
VERSION="Ver. 1.0"
TITULO_SCRIPT="Configuración SNA"
ICONO="/usr/local/bin/gsf/icons/SF-Icon.png"
INST_LIB=false
INST_PW3270=false
INST_PLUG=false

# ************************* mostrarYAD() Muestra el Formulario estandar con mensajes al usuario ***********************************
function mostrarYAD(){ 
 	yad --window-icon=$ICONO --center --width=550 --image=dialog-warning --title="$1" --text="\n $2" --button="$3"  
}

# ************************* checkear_root() Muestra dialogos de error si no se ejecuta el script como root ******************************
function checkear_root(){
	local meid=$(id -u)
	 if [ $meid -ne 0 ];
	  then
		mostrarYAD "Información" "Operación Cancelada, debe tener privilegios de #<b>root</b> para ejecutar este Asistente." "gtk-ok:0" ; exit 0 
	    exit 999
	 fi
}
# ************************* mostrar_dialogo_ERROR() Muestra dialogos de error para los formularios ***********************************
function mostrar_dialogo_ERROR(){
	mostrarYAD "Información" "Operación Cancelada, <b>NO</b> se produjeron cambios en el Sistema." "gtk-ok:0"; exit 0 
	exit 999
}
# ************************* validar_form() Valida formulario ***********************************
function validar_form(){
case $? in
    1)
	mostrar_dialogo_ERROR
	;;
    252)
	mostrar_dialogo_ERROR
	;;
    -1)
	mostrarYAD "Error" "Un error inesperado ha ocurrido, <b>NO</b> se produjeron cambios en el Sistema." "gtk-ok:0"; exit 0 
	exit 999
	;;
esac
}
# ************************* form_Reporte() Muestra el reporte de los cambios a realizar ***********************************
function form_Reporte(){
	yad --center --width=750 --image=dialog-warning --title="ATENCIÓN" \
	--text="\n <b>ATENCIÓN - Se realizarán los siguientes cambios:</b>\n \n $REP_CADENA \n\n Desea confirmar los cambios?"  \
	--button="gtk-ok:0" --button="gtk-cancel:1"
	validar_form
}



# ************************* main() **************************************
checkear_root

clear
cheq_PW3240

conf_SNA

form_Reporte
cambiar_SNA
mostrarYAD "Operación Realizada" "Los cambios fueron aplicados exitosamente" "gtk-ok"

