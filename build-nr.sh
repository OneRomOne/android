#! /bin/bash
# Build para compilar NucleaROM


# No scrollback buffer
echo -e '\0033\0143'



# Obteniendo la hora incial del arranque
res1=$(date +%s.%N)



# Colores para el terminal
red='tput setaf 1'              # red
green='tput setaf 2'            # green
yellow='tput setaf 3'           # yellow
blue='tput setaf 4'             # blue
violet='tput setaf 5'           # violet
cyan='tput setaf 6'             # cyan
white='tput setaf 7'            # white
txtbld=$(tput bold)             # Bold
bldred=${txtbld}$(tput setaf 1) # Bold red
bldgrn=${txtbld}$(tput setaf 2) # Bold green
bldblu=${txtbld}$(tput setaf 4) # Bold blue
bldcya=${txtbld}$(tput setaf 6) # Bold cyan
normal='tput sgr0'

echo "Eliga que device quiere compilar:"
echo "1 - bacon - Oneplus 1"
echo "2 - ham - Zuk z1"
echo "3 - oneplus3 - Oneplus 3"

echo "Introduzca un numero (1-3):"

read device

if [ -z "$device" ]; then
        echo "No me seas capullo!!"
                exit
fi

if [ "$device" == "1" ]; then
        device="bacon"
elif [ "$device" == "2" ]; then
        device="ham"
elif [ "$device" == "3" ]; then
        device="oneplus3"
        else
                echo "En serio??"
                exit
fi

export DEVICEVERSION=$device

echo "Introduce la version del kernel para la rom: "

read VER

if [ -z "$VER" ]; then
        echo "No me seas capullo!!"
                exit
fi

# Kernel Details
BASE_RADIOACTIVE_VER="RADIOACTIVE_"
#VER="V2.45"
RADIOACTIVE_VER="$BASE_RADIOACTIVE_VER$VER"

# Vars
export LOCALVERSION=~`echo $RADIOACTIVE_VER`


echo "Introduce la version de la rom: "

read VER_ROM

if [ -z "$VER_ROM" ]; then
        echo "No me seas capullo!!"
                exit
fi

export VER_ROM

tput bold
tput setaf 1
clear
echo -e ""
echo -e ""
echo -e "Nuclea"
echo -e "      ROM  "
echo -e "Device: "$device
echo -e ""
sleep 5
clear
echo -e ""
echo -e ""
echo -e "${bldgrn}  Configuración de entorno..."
echo -e ""
echo -e ""
. build/envsetup.sh
echo -e "Entorno configurado"
sleep 5
# Clear terminal
clear

# Funcion de limpieza del directorio de salida
echo -e "\n\n${bldgrn}  Quieres limpiar el directorio OUT?\n"
echo ""
echo -e "${bldblu}  1. Si"
echo -e "${bldblu}  2. No"
echo ""
echo ""
$normal
read askclean
if [ "$askclean" == "1" ]
then
	echo ""
	echo ""
        echo -e "${bldgrn}  Borrando archivos compilados previamente- Limpiando...."
	echo ""
	echo ""
	$normal
        make clean
        echo How much CCache do you want to utilize?
                echo Recommended CCache ranges from 50 to 100 Gigabytes
                echo HINT: CCache will help to increase build times by taking up your hard-drive space
                echo If you dont want CCache or are not sure, type 0
                read ccsize
                echo Enter path to directory you want to use for ccache.
                echo Something like /home/$USER/.ccache
                read ccpath
                export USE_CCACHE=1
                export CCACHE_DIR=$ccpath/
                prebuilts/misc/linux-x86/ccache/ccache -M $ccsize
else
	echo -e ""
	echo -e ""
	echo -e "Continua con la compilación NucleaROM, sin borrar archivos antiguos."
	echo -e ""
	echo -e ""
export USE_CCACHE=1
fi
sleep 5
# Clear terminal
clear
# Dependencias op3
echo -e ""
echo -e ""
echo -e "${bldcya}  Comprobando dependencias de $device..."
echo -e ""
echo -e ""
$normal
$green
sleep 5
breakfast $device
sleep 5
clear
# Empezar Compilación
echo -e ""
echo -e ""
echo -e "${bldcya}  Iniciando la compilación de NucleaROM...."
echo -e ""
brunch $device
echo -e ""
# Get elapsed time
$blue
res2=$(date +%s.%N)
echo -e ""
echo -e ""
echo "${bldgrn}Total Tiempo estimado: ${txtrst}${grn}$(echo "($res2 - $res1) / 60"|bc ) minutos ($(echo "$res2 - $res1"|bc ) segundos) ${txtrst}"
echo -e ""
echo -e ""


# Compilation complete
tput bold
tput setaf 1
clear
echo -e " "
echo -e " "
echo -e " Compilación Completa! Enhorabuena por el nuevo build!"

EXPORT_CCACHE=1

# Poniendo el terminal normal
$normal
