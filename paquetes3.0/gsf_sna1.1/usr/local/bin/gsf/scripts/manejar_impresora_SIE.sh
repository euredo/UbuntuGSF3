#!/bin/bash
############################################
# Asistente para Prender y Apagar Terminal de Impresión
# Modificado: 2020-11
############################################


VERSION="Ver. 1.1"
TITULO_SCRIPT="Terminal de impresion pr3287"
ICONO="/usr/local/bin/gsf/icons/SF-Icon.png"

LU_PRINTER="XXXXXXXX"
IP_SNA="10.1.4.11"



# ************************* Muestra diálogo de confirmación de Error ******************************
function form_Error(){
	RESULTADOS=$(yad --image $ICONO  --window-icon=$ICONO --image-on-top --width=500 --height=100 --center \
			--title="$TITULO_SCRIPT - $VERSION" \
			--list  --center --text="\n     No se pudo conectar la terminal de impresión: $LU_PRINTER\n \n Los detalles se encuentran en: /tmp/pr3287/$(ls -t /tmp/pr3287/ | head -1)  " --button="Cerrar:1")   # Implementar Otros
	
	pkill pr3287
	
}

# ************************* Muestra diálog de conexion ******************************
function form_Repo(){
	RESULTADOS=$(yad --image $ICONO  --window-icon=$ICONO --image-on-top --width=500 --height=100 --center \
			--title="$TITULO_SCRIPT - $VERSION" \
			--list  --center --text="\n     La terminal de impresión: $LU_PRINTER\n se encuentra activa\n \n \n Presione cerrar para liberar la sesion." --button="Cerrar:1")   # Implementar Otros
	
	pkill pr3287
	
}

# ************************* main() **************************************
pr3287 -trace -tracedir /tmp/pr3287/ -daemon -charset cp284  $LU_PRINTER@$IP_SNA

pid=$(ps -ef | grep pr3287 | grep -v "grep" | grep -v "pluma"| grep -v "yad" | awk '{print $2}')
if [ $pid > 0 ]; 
then
  form_Repo 
else
  form_Error
fi
pkill pr3287
