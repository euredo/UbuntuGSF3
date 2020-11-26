#!/bin/bash
############################################
# Asistente para Prender y Apagar Terminal de Impresión
# Modificado: 2020-11
############################################


VERSION="Ver. 1.1"
TITULO_SCRIPT="SIE Terminal de impresión"
ICONO="/usr/local/bin/gsf/icons/SF-Icon.png"

LU_PRINTER=ROTPNT04
IP_SNA="10.1.4.11"



# ************************* mostrarYAD() Muestra una ventana generica de yad co nel mensaje proporcionado ***********************************
function mostrarYAD(){ 
 	yad --window-icon=$ICONO --center --width=550 --image=dialog-warning --title="$1" --text="\n $2" --button="$3"  
}

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
if [ ! -d "/tmp/pr3287/" ];
then 
  mkdir /tmp/pr3287/
fi

if  [ -z $LU_PRINTER ]; then 
mostrarYAD "$TITULO_SCRIPT - $VERSION" "No fue definida una terminal de impresión. \n Por favor defínala a travez de la aplicación Configuración SNA" "gtk-ok"
exit 0
else
pr3287 -trace -tracedir /tmp/pr3287/ -daemon -charset cp284  $LU_PRINTER@$IP_SNA
fi

pid=$(ps -ef | grep pr3287 | grep -v "grep" | grep -v "pluma"| grep -v "yad" | awk '{print $2}')
if [ $pid > 0 ]; 
then
  form_Repo 
else
  form_Error
fi
pkill pr3287
