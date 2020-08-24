#!/bin/bash
############################################
# Asistente para Prender y Apagar Terminal de Impresión
# Modificado: 2018-02
############################################


VERSION="Ver. 1.0"
TITULO_SCRIPT="Terminal de impresion pr3287"
ICONO="/usr/local/bin/gsf/icons/SF-Icon.png"

LU_PRINTER="ROTPNT04"
IP_SNA="10.1.4.11"



# ************************* Muestra diálogos genéricos ******************************
function form_Repo(){
	RESULTADOS=$(yad --image $ICONO  --window-icon=$ICONO --image-on-top --width=500 --height=100 --center \
			--title="$TITULO_SCRIPT - $VERSION" \
			--list  --center --text="\n     La terminal de impresión: $LU_PRINTER\n se encuentra activa\n \n \n Presione cerrar para liberar la sesion." --button="Cerrar:1")   # Implementar Otros
	
	pkill pr3287
	
}

# ************************* main() **************************************
pr3287 -daemon -charset cp284  $LU_PRINTER@$IP_SNA
form_Repo 

pkill pr3287
