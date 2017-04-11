#!/bin/bash

# Script write by Felippi Crominski Magalhães
# felippicm@gmail.com
# version 0.3

#set -x

ROOT_UID=0


MPSOCBENCH_INSTALL_PAUSE=0
MPSOCBENCH_VAGRANT_INSTALL=0
MPSOCBENCH_INSTALLER_PATH=~/mpsocbench_v
MPSOCBENCH_INSTALL_PATH=/opt
MPSOCBENCH_INSTALLER_NAME='mpsocbench_installer-0.3.sh'
MPSOCBENCH_INSTALLER_FILES_TMP='installers_files_tmp'

MPSOCBENCH_WITHOUT_INTERFACE=0



MPSOCBENCH_HELP=0
MPSOCBENCH_ENVIROMENT=0
MPSOCBENCH_S_VERSION=0

MPSOCBENCH_CREATE_VAGRANT_FILE=0

CURRENT_DIR=$(pwd)

MPSOCBENCH_INSTALLER_PATH_TMP=0
MPSOCBENCH_INSTALL_PATH_TMP=0
MPSOCBENCH_INSTALL=0
MPSOCBENCH_VAGRANT_HELP=0

MPSOCBENCH_SIMPLE_TEST=0
MPSOCBENCH_CLEAR=0
MPSOCBENCH_UNINSTALL=0
MPSOCBENCH_FORCE=0

MPSOCBENCH_DEFAULT=1


MPSOCBENCH_STRING_VERSION="
	MPSocBench 2.2
	SystemC 2.3.1
	ArchC 2.4.1
	Installer MPSocBench 0.3
	ServerFcm 0.2
	
	"


function _mpsocbench_help
{
	echo "
  Installer MPSocBench 0.3
  $0 <args>

  -install		Install the MPSocBench and dependences on local host
  -env			If sudo, set Enviroment Variables, else, show code to put in your .profile
  -p			step by step
  -cv			Create vagrant file
  -createvagrant	vide -cv
  -vagrant		Install on vagrant (don't use that)
  --help		Show this help (default)
  -di=<arg>		Directory to installer, now is set= \"$MPSOCBENCH_INSTALLER_PATH\"
			A folder whith files download and a copy of this instaler will be create on that
  -dinstall=<arg>	Diretory to INSTALL MPSocBench and dependences
			Now is set \"$MPSOCBENCH_INSTALL_PATH\"
  -version		Show versions of main softwares this installer install
  -vh			Vagrant Help, show some information about vagrant whith MPSocBench.
  -st|-simpletest	A simple test
  -uninstall		Uninstall MPSoCBench, ArchC, SystemC ServerFcm, tmpFiles, $MPSOCBENCH_INSTALL_PATH/tools/compilers/(compilers)
  -clear		Clear temporary data, like \"$MPSOCBENCH_INSTALLER_PATH/$MPSOCBENCH_INSTALLER_FILES_TMP\"
  -force		Ignore Errors
  -nointerface	For not install Web Interface
  -interface	For install Web Interface <default>
  "
  
  # Not Runing because problem with session variables
  # Use \"service serverfcm start 5555\" to start web interface
	
	

echo "(pt-BR)
  Instalador MPSoCBench 0.3
  $0 <args>

  -install		Instalar o MPSocBench e dependências na máquina atual
  -env			Se sudo, configura as variáveis de ambiente, caso contrário mostra código para ser colocado no seu .profile
  -p			passo a passo
  -cv			Criar arquivo Vagrant
  -createvagrant	ver -cv
  -vagrant		Instalação no vagrant (não utilize esse)
  --help		Mostrar esse help (default)
  -di=<arg>		Diretório para o instalador, atual= \"$MPSOCBENCH_INSTALLER_PATH\"
			Uma pasta com os arquivos baixados e uma cópia desse instalador será criado nessa pasta
  -dinstall=<arg>	Diretório para INSTALAR o MPSoCBench e suas depedências
			atual= \"$MPSOCBENCH_INSTALL_PATH\"
  -version		Mostra a versões dos principais softwares desse instalador
  -vh			Vagrant Help, mostra algumas informações sobre o vagrant.
  -st|-simpletest	Um simples teste
  -uninstall		Desinstalar MPSoCBench, ArchC, SystemC, ServerFcm, tmpFiles, $MPSOCBENCH_INSTALL_PATH/tools/compilers/(compilers)
  -clear		Limpar dados temporários, ex: \"$MPSOCBENCH_INSTALLER_PATH/$MPSOCBENCH_INSTALLER_FILES_TMP\"
  -force		Ignora Erros
  -nointerface	Para não instalar a interface web
  -interface	Para instalar a interface web <default>
	
	"

}




for i in "$@"
do
	case $i in
		--install|-install|-i)
			MPSOCBENCH_INSTALL=1
			MPSOCBENCH_DEFAULT=0
		;;
		--enviroment|-enviroment|-env)
			MPSOCBENCH_ENVIROMENT=1
			MPSOCBENCH_DEFAULT=0
		;;
		--vagrant|-vagrant)
			MPSOCBENCH_VAGRANT_INSTALL=1
			MPSOCBENCH_INSTALL=1
			MPSOCBENCH_DEFAULT=0
		;;
		-h|--h|-help|--help)
			MPSOCBENCH_HELP=1
			MPSOCBENCH_DEFAULT=0
		;;
		--version|-version|-v)
			MPSOCBENCH_S_VERSION=1
			MPSOCBENCH_DEFAULT=0
		;;
		-di=*|--di=*)
			MPSOCBENCH_INSTALLER_PATH_TMP="${i#*=}"
		;;
		--dinstall=*|-dinstall=*)
			MPSOCBENCH_INSTALL_PATH_TMP="${i#*=}"
		;;
		--createvagrant|-createvagrant|-cv)
			MPSOCBENCH_CREATE_VAGRANT_FILE=1
			MPSOCBENCH_DEFAULT=0
		;;
		--vagranthelp|-vagranthelp|-vh|-vhelp)
			MPSOCBENCH_VAGRANT_HELP=1
			MPSOCBENCH_DEFAULT=0
		;;
		--clear|-clear)
			MPSOCBENCH_CLEAR=1
			MPSOCBENCH_DEFAULT=0
		;;
		--simpletest|-simpletest|-st)
			MPSOCBENCH_SIMPLE_TEST=1
			MPSOCBENCH_DEFAULT=0
		;;
		--pause|-pause|-p)
			MPSOCBENCH_INSTALL_PAUSE=1
			MPSOCBENCH_DEFAULT=0
		;;
		--uninstall|-uninstall)
			MPSOCBENCH_UNINSTALL=1
			MPSOCBENCH_DEFAULT=0
		;;
		--nointerface|-nointerface)
			MPSOCBENCH_WITHOUT_INTERFACE=1
		;;
		--interface|-interface)
			MPSOCBENCH_WITHOUT_INTERFACE=0
		;;
		--force|-force|-f)
			MPSOCBENCH_FORCE=1
		;;
		*)
			echo "ERROR: argument \"$i\" not found!!!"
			_mpsocbench_help
			echo "ERROR: argument \"$i\" not found!!!"
			exit
		;;
	esac
done


if [[ $MPSOCBENCH_DEFAULT == 1 ]]
then
	MPSOCBENCH_HELP=1
fi


if [[ $MPSOCBENCH_VAGRANT_INSTALL == 1 ]]
then
	MPSOCBENCH_INSTALLER_PATH='/vagrant'
fi

if [[ $MPSOCBENCH_INSTALLER_PATH_TMP != 0 ]]
then
	MPSOCBENCH_INSTALLER_PATH=$MPSOCBENCH_INSTALLER_PATH_TMP
fi

if [[ $MPSOCBENCH_INSTALL_PATH_TMP != 0 ]]
then
	MPSOCBENCH_INSTALL_PATH=$MPSOCBENCH_INSTALL_PATH_TMP
fi

if [[ $MPSOCBENCH_VAGRANT_INSTALL == 0 ]]
then
	eval MPSOCBENCH_INSTALLER_PATH=$MPSOCBENCH_INSTALLER_PATH
	eval MPSOCBENCH_INSTALL_PATH=$MPSOCBENCH_INSTALL_PATH
fi




if [[ $MPSOCBENCH_HELP == 1 ]]
then
	_mpsocbench_help

fi

if [[ $MPSOCBENCH_S_VERSION == 1 ]]
then
	echo "MPSocBench 2.2
	SystemC 2.3.1
	ArchC 2.4.1
	Instalador MPSocBench 0.3
	Serverfcm 0.2
	
	archc_arm_toolchain_20150102_64bit.tar.bz2
	archc_powerpc_toolchain_20141215_64bit.tar.bz2
	archc_mips_toolchain_20141215_64bit.tar.bz2
	archc_sparc_toolchain_20141215_64bit.tar.bz2
	
	"
fi


function _exit
{
	if [[ $MPSOCBENCH_FORCE==0 ]];
	then
		exit
	fi
}


function serverfcm()
{
	if [[ $MPSOCBENCH_WITHOUT_INTERFACE == 1 ]]
	then
		return
	fi
	
	CURRENT_DIR_serverfcm=$(pwd)
	
	cd $MPSOCBENCH_INSTALLER_PATH/$MPSOCBENCH_INSTALLER_FILES_TMP
	
	echo "----------------------------------------------------"
	echo "ServerFcm - Install Server to Web Interface $(date +%y\/%m\/%d\ \-\ %H:%M:%S)
		on: ($MPSOCBENCH_INSTALL_PATH/serverfcm)
	
	"
	if [[ $MPSOCBENCH_INSTALL_PAUSE == 1 ]]
	then
		read -p "Press Enter to continue" nothing
	fi
	
	
	tmp_size=$(du -s serverfcm-0.2.tar.gz --bytes | cut -f1)
	if [[ $tmp_size != 1234 ]];
	then
		rm -rf serverfcm-0.2.tar.gz
		wget -O serverfcm-0.2.tar.gz http://fcmbr.com/downloads/serverfcm-0.2.tar.gz
		if [ ! -f serverfcm-0.2.tar.gz ];
		then
			echo "File serverfcm-0.2.tar.gz does not exist, please download \"Server MPSoCBench Web Interface\" in http://fcmbr.com/mpsocbench"
			echo -e "File serverfcm-0.2.tar.gz does not exist, please download \"Server MPSoCBench Web Interface\" in http://fcmbr.com/mpsocbench" >>$MPSOCBENCH_INSTALLER_PATH/log/mpsocbench_installer.log
			_exit
		fi
	fi
	
	
	# Remove old version
	rm -rf $MPSOCBENCH_INSTALL_PATH/serverfcm-0.1
	
	
	rm -rf $MPSOCBENCH_INSTALL_PATH/serverfcm-0.2
	rm -rf $MPSOCBENCH_INSTALL_PATH/serverfcm
	tar xf serverfcm-0.2.tar.gz
	mv  serverfcm-0.2/ $MPSOCBENCH_INSTALL_PATH/serverfcm-0.2

	ln -s $MPSOCBENCH_INSTALL_PATH/serverfcm-0.2 $MPSOCBENCH_INSTALL_PATH/serverfcm
	
	
	if [ ! -d $MPSOCBENCH_INSTALL_PATH/serverfcm ];
	then
		echo "WARNING, folder \"$MPSOCBENCH_INSTALL_PATH/serverfcm\" not exist"
		mkdir $MPSOCBENCH_INSTALL_PATH/serverfcm
	fi
	
	
	if [ ! -d $MPSOCBENCH_INSTALL_PATH/serverfcm/bin ];
	then
	
		mkdir $MPSOCBENCH_INSTALL_PATH/serverfcm/bin
	fi

	if [ -d $MPSOCBENCH_INSTALL_PATH/systemc/lib-linux ]; # x86
	then
		cp $MPSOCBENCH_INSTALL_PATH/serverfcm/files/serverfcm86 $MPSOCBENCH_INSTALL_PATH/serverfcm/bin/serverfcm
	
	else # x64
		cp $MPSOCBENCH_INSTALL_PATH/serverfcm/files/serverfcm64 $MPSOCBENCH_INSTALL_PATH/serverfcm/bin/serverfcm
		
	fi

	cp $MPSOCBENCH_INSTALL_PATH/serverfcm/files/MPSoCBench $MPSOCBENCH_INSTALL_PATH/mpsocbench/

	# Temporario, para adicionar "-static" na compilação
	cp $MPSOCBENCH_INSTALL_PATH/serverfcm/files/Makefile.rules $MPSOCBENCH_INSTALL_PATH/mpsocbench/
	
	if [ $UID == $ROOT_UID ];
	then
	
		rm -rf /etc/init.d/serverfcm
		cp $MPSOCBENCH_INSTALL_PATH/serverfcm/files/serverfcm /etc/init.d/serverfcm
		chmod +x /etc/init.d/serverfcm
	else
		echo "
		
		Service \"serverfcm\" will not create because you don't have sudo permission!
		
		"
	
	fi
	
	
config_server="{\n
\"server\": {\n
    \"dir_mpsocbench_install\":\"$MPSOCBENCH_INSTALL_PATH/mpsocbench\",\n
    \"serverfcm\":\"$MPSOCBENCH_INSTALL_PATH/serverfcm\",\n
    \"dir_public\":\"$MPSOCBENCH_INSTALL_PATH/serverfcm/public\",\n
    \"port_server\":\"5555\"\n
  },\n
  \n
  \"optionCacheFiles\": [ "
  
  
file_list=(  "$MPSOCBENCH_INSTALL_PATH/mpsocbench/processors/arm/arm_nonblock.ac"
			 "$MPSOCBENCH_INSTALL_PATH/mpsocbench/processors/powerpc/powerpc_nonblock.ac"
			 "$MPSOCBENCH_INSTALL_PATH/mpsocbench/processors/sparc/sparc_nonblock.ac"
			 "$MPSOCBENCH_INSTALL_PATH/mpsocbench/processors/mips/mips_nonblock.ac"
			 "$MPSOCBENCH_INSTALL_PATH/mpsocbench/processors/arm/arm_block.ac"
			 "$MPSOCBENCH_INSTALL_PATH/mpsocbench/processors/powerpc/powerpc_block.ac"
			 "$MPSOCBENCH_INSTALL_PATH/mpsocbench/processors/sparc/sparc_block.ac"
			 "$MPSOCBENCH_INSTALL_PATH/mpsocbench/processors/mips/mips_block.ac"
			  )
			
file_oring=( "arm_nonblock.ac"
			 "powerpc_nonblock.ac"
			 "sparc_nonblock.ac"
			 "mips_nonblock.ac"
			 "arm_block.ac"
			 "powerpc_block.ac"
			 "sparc_block.ac"
			 "mips_block.ac"
			  )

	arraylength=${#file_list[@]}

	if [[ ${arraylength}>0 ]];
	then
		config_server="${config_server} \"${file_list[0]}\""
	fi

	for (( i=1; i<${arraylength}; i++ ));
	do
		config_server="${config_server},\n \"${file_list[$i]}\""

	done
	  
	config_server="${config_server} ]\n}  "
	 
	rm "$MPSOCBENCH_INSTALL_PATH/serverfcm/conf/config_server.cfg"
	echo -e $config_server > "$MPSOCBENCH_INSTALL_PATH/serverfcm/conf/config_server.cfg"

	# Copy templateFiles
	for (( i=0; i<${arraylength}; i++ ));
	do
		cp "$MPSOCBENCH_INSTALL_PATH/serverfcm/templates/${file_oring[$i]}.template" "${file_list[$i]}.template"

	done
	
	rm -rf $MPSOCBENCH_INSTALL_PATH/serverfcm/bin/config_plataform.cfg
	rm -rf $MPSOCBENCH_INSTALL_PATH/serverfcm/bin/config_server.cfg
	rm -rf $MPSOCBENCH_INSTALL_PATH/serverfcm/public/config_plataform.cfg
	rm -rf $MPSOCBENCH_INSTALL_PATH/serverfcm/public/config_server.cfg

	ln -s ../conf/config_server.cfg $MPSOCBENCH_INSTALL_PATH/serverfcm/bin/
	ln -s ../conf/config_plataform.cfg $MPSOCBENCH_INSTALL_PATH/serverfcm/bin/
	
	ln -s ../conf/config_server.cfg $MPSOCBENCH_INSTALL_PATH/serverfcm/public/
	ln -s ../conf/config_plataform.cfg $MPSOCBENCH_INSTALL_PATH/serverfcm/public/
	
	cd $CURRENT_DIR_serverfcm
	
}



function setInstallerPermission()
{
	chmod 777 -R "$MPSOCBENCH_INSTALLER_PATH"
	# chown $SUDO_USER -R "$MPSOCBENCH_INSTALLER_PATH"
}

function isSudo()
{
	if [ $UID != $ROOT_UID ];
	then
		echo "You don't have sudo permission, some applications may not be properly installed."
		echo "It is recommended that you use sudo: sudo $0"
		read -p "You are sure then you want continue whitout sudo permission? (y/n)" -n 1 -r
		if [[ ! $REPLY =~ ^[Yy]$ ]]
		then
			echo "

	Canceled by User
		
	"
			exit
		fi
		echo "
		"
	fi
}


# Copia arquivos para a pasta $MPSOCBENCH_INSTALLER_PATH, e cria o Vagrantfile
function copyCreateFiles()
{
	# isSudo

	vagrantFileBase64="IyAtKi0gbW9kZTogcnVieSAtKi0KIyB2aTogc2V0IGZ0PXJ1YnkgOgoKIyBWYWdyYW50ZmlsZSBB
UEkvc3ludGF4IHZlcnNpb24uIERvbid0IHRvdWNoIHVubGVzcyB5b3Uga25vdyB3aGF0IHlvdSdy
ZSBkb2luZyEKVkFHUkFOVEZJTEVfQVBJX1ZFUlNJT04gPSAiMiIKClZhZ3JhbnQuY29uZmlndXJl
KFZBR1JBTlRGSUxFX0FQSV9WRVJTSU9OKSBkbyB8Y29uZmlnfAogICMgQWxsIFZhZ3JhbnQgY29u
ZmlndXJhdGlvbiBpcyBkb25lIGhlcmUuIFRoZSBtb3N0IGNvbW1vbiBjb25maWd1cmF0aW9uCiAg
IyBvcHRpb25zIGFyZSBkb2N1bWVudGVkIGFuZCBjb21tZW50ZWQgYmVsb3cuIEZvciBhIGNvbXBs
ZXRlIHJlZmVyZW5jZSwKICAjIHBsZWFzZSBzZWUgdGhlIG9ubGluZSBkb2N1bWVudGF0aW9uIGF0
IHZhZ3JhbnR1cC5jb20uCgogICMgRXZlcnkgVmFncmFudCB2aXJ0dWFsIGVudmlyb25tZW50IHJl
cXVpcmVzIGEgYm94IHRvIGJ1aWxkIG9mZiBvZi4KICBjb25maWcudm0uYm94ID0gInVidW50dS90
cnVzdHk2NCIKICAKICAjIGluY3JlYXNlIHRoZSBzd2FwIG1lbW9yeSwgd2l0aG91dCBpdCwgdGhl
IHN3YXAgc2l6ZSBpcyB6ZXJvCiAgY29uZmlnLnZtLnByb3Zpc2lvbiA6c2hlbGwsIHBhdGg6ICJp
bmNyZWFzZV9zd2FwLnNoIgoKICAjIEluc3RhbGwgTVBTb2NCZW5jaCBhbmQgb3RoZXJzIGRlcGVu
ZGVuY2llcwogIGNvbmZpZy52bS5wcm92aXNpb24gOnNoZWxsLCBwYXRoOiAibXBzb2NiZW5jaF9p
bnN0YWxsZXItMC4zLnNoIiwgYXJnczogIi12YWdyYW50IgogIAogIAoKICAjIFRoZSB1cmwgZnJv
bSB3aGVyZSB0aGUgJ2NvbmZpZy52bS5ib3gnIGJveCB3aWxsIGJlIGZldGNoZWQgaWYgaXQKICAj
IGRvZXNuJ3QgYWxyZWFkeSBleGlzdCBvbiB0aGUgdXNlcidzIHN5c3RlbS4KICAjIGNvbmZpZy52
bS5ib3hfdXJsID0gImh0dHBzOi8vdmFncmFudGNsb3VkLmNvbS9oYXNoaWNvcnAvYm94ZXMvcHJl
Y2lzZTMyL3ZlcnNpb25zLzEvcHJvdmlkZXJzL3ZpcnR1YWxib3guYm94IgoKICAjIENyZWF0ZSBh
IGZvcndhcmRlZCBwb3J0IG1hcHBpbmcgd2hpY2ggYWxsb3dzIGFjY2VzcyB0byBhIHNwZWNpZmlj
IHBvcnQKICAjIHdpdGhpbiB0aGUgbWFjaGluZSBmcm9tIGEgcG9ydCBvbiB0aGUgaG9zdCBtYWNo
aW5lLiBJbiB0aGUgZXhhbXBsZSBiZWxvdywKICAjIGFjY2Vzc2luZyAibG9jYWxob3N0OjgwODAi
IHdpbGwgYWNjZXNzIHBvcnQgODAgb24gdGhlIGd1ZXN0IG1hY2hpbmUuCiAgIyBjb25maWcudm0u
bmV0d29yayA6Zm9yd2FyZGVkX3BvcnQsIGd1ZXN0OiA4MCwgaG9zdDogODA4MAoKICAjIENyZWF0
ZSBhIHByaXZhdGUgbmV0d29yaywgd2hpY2ggYWxsb3dzIGhvc3Qtb25seSBhY2Nlc3MgdG8gdGhl
IG1hY2hpbmUKICAjIHVzaW5nIGEgc3BlY2lmaWMgSVAuCiAgY29uZmlnLnZtLm5ldHdvcmsgOnBy
aXZhdGVfbmV0d29yaywgaXA6ICIxOTIuMTY4LjMzLjEwIgoKICAjIENyZWF0ZSBhIHB1YmxpYyBu
ZXR3b3JrLCB3aGljaCBnZW5lcmFsbHkgbWF0Y2hlZCB0byBicmlkZ2VkIG5ldHdvcmsuCiAgIyBC
cmlkZ2VkIG5ldHdvcmtzIG1ha2UgdGhlIG1hY2hpbmUgYXBwZWFyIGFzIGFub3RoZXIgcGh5c2lj
YWwgZGV2aWNlIG9uCiAgIyB5b3VyIG5ldHdvcmsuCiAgIyBjb25maWcudm0ubmV0d29yayA6cHVi
bGljX25ldHdvcmsKCiAgIyBJZiB0cnVlLCB0aGVuIGFueSBTU0ggY29ubmVjdGlvbnMgbWFkZSB3
aWxsIGVuYWJsZSBhZ2VudCBmb3J3YXJkaW5nLgogICMgRGVmYXVsdCB2YWx1ZTogZmFsc2UKICAj
IGNvbmZpZy5zc2guZm9yd2FyZF9hZ2VudCA9IHRydWUKCiAgIyBTaGFyZSBhbiBhZGRpdGlvbmFs
IGZvbGRlciB0byB0aGUgZ3Vlc3QgVk0uIFRoZSBmaXJzdCBhcmd1bWVudCBpcwogICMgdGhlIHBh
dGggb24gdGhlIGhvc3QgdG8gdGhlIGFjdHVhbCBmb2xkZXIuIFRoZSBzZWNvbmQgYXJndW1lbnQg
aXMKICAjIHRoZSBwYXRoIG9uIHRoZSBndWVzdCB0byBtb3VudCB0aGUgZm9sZGVyLiBBbmQgdGhl
IG9wdGlvbmFsIHRoaXJkCiAgIyBhcmd1bWVudCBpcyBhIHNldCBvZiBub24tcmVxdWlyZWQgb3B0
aW9ucy4KICAjIGNvbmZpZy52bS5zeW5jZWRfZm9sZGVyICIuLi9kYXRhIiwgIi92YWdyYW50X2Rh
dGEiCgogICMgUHJvdmlkZXItc3BlY2lmaWMgY29uZmlndXJhdGlvbiBzbyB5b3UgY2FuIGZpbmUt
dHVuZSB2YXJpb3VzCiAgIyBiYWNraW5nIHByb3ZpZGVycyBmb3IgVmFncmFudC4gVGhlc2UgZXhw
b3NlIHByb3ZpZGVyLXNwZWNpZmljIG9wdGlvbnMuCiAgIyBFeGFtcGxlIGZvciBWaXJ0dWFsQm94
OgogICMKICAjIGNvbmZpZy52bS5wcm92aWRlciA6dmlydHVhbGJveCBkbyB8dmJ8CiAgIyAgICMg
RG9uJ3QgYm9vdCB3aXRoIGhlYWRsZXNzIG1vZGUKICAjICAgdmIuZ3VpID0gdHJ1ZQogICMKICAj
ICAgIyBVc2UgVkJveE1hbmFnZSB0byBjdXN0b21pemUgdGhlIFZNLiBGb3IgZXhhbXBsZSB0byBj
aGFuZ2UgbWVtb3J5OgogICMgICB2Yi5jdXN0b21pemUgWyJtb2RpZnl2bSIsIDppZCwgIi0tbWVt
b3J5IiwgIjEwMjQiXQogICMgZW5kCiAgIwogICMgVmlldyB0aGUgZG9jdW1lbnRhdGlvbiBmb3Ig
dGhlIHByb3ZpZGVyIHlvdSdyZSB1c2luZyBmb3IgbW9yZQogICMgaW5mb3JtYXRpb24gb24gYXZh
aWxhYmxlIG9wdGlvbnMuCgogICMgRW5hYmxlIHByb3Zpc2lvbmluZyB3aXRoIFB1cHBldCBzdGFu
ZCBhbG9uZS4gIFB1cHBldCBtYW5pZmVzdHMKICAjIGFyZSBjb250YWluZWQgaW4gYSBkaXJlY3Rv
cnkgcGF0aCByZWxhdGl2ZSB0byB0aGlzIFZhZ3JhbnRmaWxlLgogICMgWW91IHdpbGwgbmVlZCB0
byBjcmVhdGUgdGhlIG1hbmlmZXN0cyBkaXJlY3RvcnkgYW5kIGEgbWFuaWZlc3QgaW4KICAjIHRo
ZSBmaWxlIGJhc2UucHAgaW4gdGhlIG1hbmlmZXN0c19wYXRoIGRpcmVjdG9yeS4KICAjCiAgIyBB
biBleGFtcGxlIFB1cHBldCBtYW5pZmVzdCB0byBwcm92aXNpb24gdGhlIG1lc3NhZ2Ugb2YgdGhl
IGRheToKICAjCiAgIyAjIGdyb3VwIHsgInB1cHBldCI6CiAgIyAjICAgZW5zdXJlID0+ICJwcmVz
ZW50IiwKICAjICMgfQogICMgIwogICMgIyBGaWxlIHsgb3duZXIgPT4gMCwgZ3JvdXAgPT4gMCwg
bW9kZSA9PiAwNjQ0IH0KICAjICMKICAjICMgZmlsZSB7ICcvZXRjL21vdGQnOgogICMgIyAgIGNv
bnRlbnQgPT4gIldlbGNvbWUgdG8geW91ciBWYWdyYW50LWJ1aWx0IHZpcnR1YWwgbWFjaGluZSEK
ICAjICMgICAgICAgICAgICAgICBNYW5hZ2VkIGJ5IFB1cHBldC5cbiIKICAjICMgfQogICMKICAj
IGNvbmZpZy52bS5wcm92aXNpb24gOnB1cHBldCBkbyB8cHVwcGV0fAogICMgICBwdXBwZXQubWFu
aWZlc3RzX3BhdGggPSAibWFuaWZlc3RzIgogICMgICBwdXBwZXQubWFuaWZlc3RfZmlsZSAgPSAi
c2l0ZS5wcCIKICAjIGVuZAoKICAjIEVuYWJsZSBwcm92aXNpb25pbmcgd2l0aCBjaGVmIHNvbG8s
IHNwZWNpZnlpbmcgYSBjb29rYm9va3MgcGF0aCwgcm9sZXMKICAjIHBhdGgsIGFuZCBkYXRhX2Jh
Z3MgcGF0aCAoYWxsIHJlbGF0aXZlIHRvIHRoaXMgVmFncmFudGZpbGUpLCBhbmQgYWRkaW5nCiAg
IyBzb21lIHJlY2lwZXMgYW5kL29yIHJvbGVzLgogICMKICAjIGNvbmZpZy52bS5wcm92aXNpb24g
OmNoZWZfc29sbyBkbyB8Y2hlZnwKICAjICAgY2hlZi5jb29rYm9va3NfcGF0aCA9ICIuLi9teS1y
ZWNpcGVzL2Nvb2tib29rcyIKICAjICAgY2hlZi5yb2xlc19wYXRoID0gIi4uL215LXJlY2lwZXMv
cm9sZXMiCiAgIyAgIGNoZWYuZGF0YV9iYWdzX3BhdGggPSAiLi4vbXktcmVjaXBlcy9kYXRhX2Jh
Z3MiCiAgIyAgIGNoZWYuYWRkX3JlY2lwZSAibXlzcWwiCiAgIyAgIGNoZWYuYWRkX3JvbGUgIndl
YiIKICAjCiAgIyAgICMgWW91IG1heSBhbHNvIHNwZWNpZnkgY3VzdG9tIEpTT04gYXR0cmlidXRl
czoKICAjICAgY2hlZi5qc29uID0geyA6bXlzcWxfcGFzc3dvcmQgPT4gImZvbyIgfQogICMgZW5k
CgogICMgRW5hYmxlIHByb3Zpc2lvbmluZyB3aXRoIGNoZWYgc2VydmVyLCBzcGVjaWZ5aW5nIHRo
ZSBjaGVmIHNlcnZlciBVUkwsCiAgIyBhbmQgdGhlIHBhdGggdG8gdGhlIHZhbGlkYXRpb24ga2V5
IChyZWxhdGl2ZSB0byB0aGlzIFZhZ3JhbnRmaWxlKS4KICAjCiAgIyBUaGUgT3BzY29kZSBQbGF0
Zm9ybSB1c2VzIEhUVFBTLiBTdWJzdGl0dXRlIHlvdXIgb3JnYW5pemF0aW9uIGZvcgogICMgT1JH
TkFNRSBpbiB0aGUgVVJMIGFuZCB2YWxpZGF0aW9uIGtleS4KICAjCiAgIyBJZiB5b3UgaGF2ZSB5
b3VyIG93biBDaGVmIFNlcnZlciwgdXNlIHRoZSBhcHByb3ByaWF0ZSBVUkwsIHdoaWNoIG1heSBi
ZQogICMgSFRUUCBpbnN0ZWFkIG9mIEhUVFBTIGRlcGVuZGluZyBvbiB5b3VyIGNvbmZpZ3VyYXRp
b24uIEFsc28gY2hhbmdlIHRoZQogICMgdmFsaWRhdGlvbiBrZXkgdG8gdmFsaWRhdGlvbi5wZW0u
CiAgIwogICMgY29uZmlnLnZtLnByb3Zpc2lvbiA6Y2hlZl9jbGllbnQgZG8gfGNoZWZ8CiAgIyAg
IGNoZWYuY2hlZl9zZXJ2ZXJfdXJsID0gImh0dHBzOi8vYXBpLm9wc2NvZGUuY29tL29yZ2FuaXph
dGlvbnMvT1JHTkFNRSIKICAjICAgY2hlZi52YWxpZGF0aW9uX2tleV9wYXRoID0gIk9SR05BTUUt
dmFsaWRhdG9yLnBlbSIKICAjIGVuZAogICMKICAjIElmIHlvdSdyZSB1c2luZyB0aGUgT3BzY29k
ZSBwbGF0Zm9ybSwgeW91ciB2YWxpZGF0b3IgY2xpZW50IGlzCiAgIyBPUkdOQU1FLXZhbGlkYXRv
ciwgcmVwbGFjaW5nIE9SR05BTUUgd2l0aCB5b3VyIG9yZ2FuaXphdGlvbiBuYW1lLgogICMKICAj
IElmIHlvdSBoYXZlIHlvdXIgb3duIENoZWYgU2VydmVyLCB0aGUgZGVmYXVsdCB2YWxpZGF0aW9u
IGNsaWVudCBuYW1lIGlzCiAgIyBjaGVmLXZhbGlkYXRvciwgdW5sZXNzIHlvdSBjaGFuZ2VkIHRo
ZSBjb25maWd1cmF0aW9uLgogICMKICAjICAgY2hlZi52YWxpZGF0aW9uX2NsaWVudF9uYW1lID0g
Ik9SR05BTUUtdmFsaWRhdG9yIgogIAogIGNvbmZpZy52bS5wcm92aWRlciAidmlydHVhbGJveCIg
ZG8gfHZ8CgkgIGhvc3QgPSBSYkNvbmZpZzo6Q09ORklHWydob3N0X29zJ10KCgkgICMgR2l2ZSBW
TSAxLzQgc3lzdGVtIG1lbW9yeSAmIGFjY2VzcyB0byBhbGwgY3B1IGNvcmVzIG9uIHRoZSBob3N0
CgkgIGlmIGhvc3QgPX4gL2Rhcndpbi8KCSAgICBjcHVzID0gYHN5c2N0bCAtbiBody5uY3B1YC50
b19pCgkgICAgIyBzeXNjdGwgcmV0dXJucyBCeXRlcyBhbmQgd2UgbmVlZCB0byBjb252ZXJ0IHRv
IE1CCgkgICAgbWVtID0gYHN5c2N0bCAtbiBody5tZW1zaXplYC50b19pIC8gMTAyNCAvIDEwMjQg
LyA0CgkgIGVsc2lmIGhvc3QgPX4gL2xpbnV4LwoJICAgIGNwdXMgPSBgbnByb2NgLnRvX2kKCSAg
ICAjIG1lbWluZm8gc2hvd3MgS0IgYW5kIHdlIG5lZWQgdG8gY29udmVydCB0byBNQgoJICAgIG1l
bSA9IGBncmVwICdNZW1Ub3RhbCcgL3Byb2MvbWVtaW5mbyB8IHNlZCAtZSAncy9NZW1Ub3RhbDov
LycgLWUgJ3MvIGtCLy8nYC50b19pIC8gMTAyNCAvIDQKCSAgZWxzZSAjIHNvcnJ5IFdpbmRvd3Mg
Zm9sa3MsIEkgY2FuJ3QgaGVscCB5b3UKCSAgICBjcHVzID0gMgoJICAgIG1lbSA9IDEwMjQKCSAg
ZW5kCgoJICB2LmN1c3RvbWl6ZSBbIm1vZGlmeXZtIiwgOmlkLCAiLS1tZW1vcnkiLCBtZW1dCgkg
IHYuY3VzdG9taXplIFsibW9kaWZ5dm0iLCA6aWQsICItLWNwdXMiLCBjcHVzXQoJZW5kCiAgCiAg
CiAgCmVuZAo="
	
increase_swap64="IyEvYmluL3NoCgojIHNpemUgb2Ygc3dhcGZpbGUgaW4gbWVnYWJ5dGVzCnN3YXBzaXplPTEwMjQK
CiMgZG9lcyB0aGUgc3dhcCBmaWxlIGFscmVhZHkgZXhpc3Q/CmdyZXAgLXEgInN3YXBmaWxlIiAv
ZXRjL2ZzdGFiCgojIGlmIG5vdCB0aGVuIGNyZWF0ZSBpdAppZiBbICQ/IC1uZSAwIF07IHRoZW4K
ICBlY2hvICJzd2FwZmlsZSBub3QgZm91bmQuIEFkZGluZyBzd2FwZmlsZS4iCiAgZmFsbG9jYXRl
IC1sICR7c3dhcHNpemV9TSAvc3dhcGZpbGUKICBjaG1vZCA2MDAgL3N3YXBmaWxlCiAgbWtzd2Fw
IC9zd2FwZmlsZQogIHN3YXBvbiAvc3dhcGZpbGUKICBlY2hvICIvc3dhcGZpbGUgbm9uZSBzd2Fw
IGRlZmF1bHRzIDAgMCIgPj4gL2V0Yy9mc3RhYgplbHNlCiAgZWNobyAic3dhcGZpbGUgZm91bmQu
IE5vIGNoYW5nZXMgbWFkZS4iCmZpCgojIG91dHB1dCByZXN1bHRzIHRvIHRlcm1pbmFsCmRmIC1o
CmNhdCAvcHJvYy9zd2FwcwpjYXQgL3Byb2MvbWVtaW5mbyB8IGdyZXAgU3dhcAo="	
	
	
	if [ ! -d "$MPSOCBENCH_INSTALLER_PATH" ];
	then
		mkdir "$MPSOCBENCH_INSTALLER_PATH"
	fi
	
	rm -rf $MPSOCBENCH_INSTALLER_PATH/log
	
	if [ ! -d "$MPSOCBENCH_INSTALLER_PATH/log" ];
	then
		mkdir "$MPSOCBENCH_INSTALLER_PATH/log"
	fi
	
	rm -rf "$MPSOCBENCH_INSTALLER_PATH/Vagrantfile"
	echo $vagrantFileBase64 | base64 -d -i > "$MPSOCBENCH_INSTALLER_PATH/Vagrantfile"
	
	rm -rf "$MPSOCBENCH_INSTALLER_PATH/increase_swap.sh"
	echo $increase_swap64 | base64 -d -i > "$MPSOCBENCH_INSTALLER_PATH/increase_swap.sh"
	
	
	if [ "$MPSOCBENCH_INSTALLER_PATH" != "$CURRENT_DIR" ];
	then
		cp -u -f "$CURRENT_DIR/$0" "$MPSOCBENCH_INSTALLER_PATH/$MPSOCBENCH_INSTALLER_NAME"
		chmod +x "$MPSOCBENCH_INSTALLER_PATH/$MPSOCBENCH_INSTALLER_NAME"
	fi
	
	if [ -d "$CURRENT_DIR/$MPSOCBENCH_INSTALLER_FILES_TMP" ] && [[ "$MPSOCBENCH_INSTALLER_PATH" != "$CURRENT_DIR" ]];
	then
		if [ ! -d "$MPSOCBENCH_INSTALLER_PATH/$MPSOCBENCH_INSTALLER_FILES_TMP" ];
		then
			mkdir "$MPSOCBENCH_INSTALLER_PATH/$MPSOCBENCH_INSTALLER_FILES_TMP"
		fi
		cp -R -u "$CURRENT_DIR/$MPSOCBENCH_INSTALLER_FILES_TMP" "$MPSOCBENCH_INSTALLER_PATH/"
	fi
	
	setInstallerPermission

}



function vagrantHelp()
{
	echo "
  Vagrant help!
  Files to vagrant create and copy to $MPSOCBENCH_INSTALLER_PATH
  Be sure to install VirtualBox and before, the Vagrant
 
  To create the virtual machine, enter the folder $MPSOCBENCH_INSTALLER_PATH and type \"vagrant up\".
  The first time, take considerable time to download the virtual machine, in other times, will not be necessary to download.

  To ssh on vagrant machine, (inside folder $MPSOCBENCH_INSTALLER_PATH) run \"vagrant ssh\"
  To shutdown vagrant machine, (inside folder $MPSOCBENCH_INSTALLER_PATH) run \"vagrant halt\"

	"

echo " (pt-BR)
  Vagrant help!
  Arquivos para o vagrant criados e copiados para $MPSOCBENCH_INSTALLER_PATH
  Certifique se de instalar o VirtualBox e depois o Vagrant

  Para criar a maquina virtual, entre na pasta $MPSOCBENCH_INSTALLER_PATH e digite \"vagrant up\".
  Na primeira vez, levará um tempo considerável para fazer download da maquina virtual, nas demais vezes, não sera necessário o download.

  Para ssh na maquina vagrant, (dentro da pasta $MPSOCBENCH_INSTALLER_PATH) executar \"vagrant ssh\"
  Para desligar a maquina vagrant, (dentro da pasta $MPSOCBENCH_INSTALLER_PATH) executar \"vagrant halt\"

	"
}


function enviroment()
{

echo "----------------------------------------------------"
	echo "Setting enviroment variables"
	if [[ $MPSOCBENCH_INSTALL_PAUSE == 1 ]]
	then
		read -p "Press enter to continue" nothing
	fi


enviroment="export SERVERFCM=$MPSOCBENCH_INSTALL_PATH/serverfcm\nexport MPSOCBENCH=$MPSOCBENCH_INSTALL_PATH/mpsocbench\nexport ARP=\$PWD\nexport HOST_OS=linux64\nexport SYSTEMC=$MPSOCBENCH_INSTALL_PATH/systemc\nexport TLM_PATH=$MPSOCBENCH_INSTALL_PATH/systemc/include\nexport LD_LIBRARY_PATH=$MPSOCBENCH_INSTALL_PATH/systemc/lib-linux64:\$LD_LIBRARY_PATH\nexport PKG_CONFIG_PATH=$MPSOCBENCH_INSTALL_PATH/systemc/lib-linux64/pkgconfig:\$PKG_CONFIG_PATH\nexport PATH=$MPSOCBENCH_INSTALL_PATH/tools/compilers/mips-newlib-elf/bin:$MPSOCBENCH_INSTALL_PATH/tools/compilers/arm-newlib-eabi/bin:$MPSOCBENCH_INSTALL_PATH/tools/compilers/powerpc-newlib-elf/bin:$MPSOCBENCH_INSTALL_PATH/tools/compilers/sparc-newlib-elf/bin:\$PATH\nexport PATH=$MPSOCBENCH_INSTALL_PATH/archc/bin:\$PATH\nexport ARCHC_PATH=$MPSOCBENCH_INSTALL_PATH/archc\nexport LD_LIBRARY_PATH=$MPSOCBENCH_INSTALL_PATH/archc/lib:\$LD_LIBRARY_PATH\nexport PKG_CONFIG_PATH=$MPSOCBENCH_INSTALL_PATH/archc/lib/pkgconfig:\$PKG_CONFIG_PATH\nexport ARCHC_PREFIX=$MPSOCBENCH_INSTALL_PATH/archc\nexport PATH=$MPSOCBENCH_INSTALL_PATH/mpsocbench:\$PATH\nexport PATH=$MPSOCBENCH_INSTALL_PATH/serverfcm/bin:\$PATH\n"
	
	
	
	if [[ $MPSOCBENCH_WITHOUT_INTERFACE == 0 ]]
	then
		echo -e $enviroment > "$MPSOCBENCH_INSTALL_PATH/serverfcm/mpsocbench_env.sh"
		chmod +x $MPSOCBENCH_INSTALL_PATH/serverfcm/mpsocbench_env.sh
	fi
	
	
	
	
	if [ $UID == $ROOT_UID ];
	then
		rm -rf "/etc/profile.d/mpsocbench_env.sh"
		echo "Setting enviroment variables to ALL users, coping file to /etc/profile.d/mpsocbench_env.sh"
		echo -e $enviroment > "/etc/profile.d/mpsocbench_env.sh"
		# Habilitar execucao de scripts
		chmod +x /etc/profile.d/mpsocbench_env.sh
		
	else
		echo -e "\n\n\n\n          !!!!         ATENTION!!!         !!!!"
		echo -e "\n\n ATENTION - because you don't have sudo permission, enviroment variable don't will be Setting\n"
		echo "For setting enviroment variables to current user, copy following lines to file ~/.profile"
		echo "# ---------- ~/.profile -------"
		echo -e $enviroment
		echo "# ----------------"
		echo ""

	fi
	
	echo -e "To complete the installation, logout and login or only do new login, to that, execute: \"bash -l\"
Avoid using \"sudo\" to build and run plataforms

"
	
}




function mpsocbenchInstall()
{
	echo "----------------------------------------------------"
	echo "----------------------------------------------------"
	echo "Install SystemC, ArchC e MPSocBench $(date +%y\/%m\/%d\ \-\ %H:%M:%S)"
	echo "
	Log of instalation will be stored in $MPSOCBENCH_INSTALLER_PATH/log
	"
	
	if [ $UID == $ROOT_UID ];
	then
		echo -e "\n\n\nInstalling MPSocBench with sudo $(date +%y\/%m\/%d\ \-\ %H:%M:%S)" >>$MPSOCBENCH_INSTALLER_PATH/log/mpsocbench_installer.log
	else
		echo -e "\n\n\nInstalling MPSocBench without sudo $(date +%y\/%m\/%d\ \-\ %H:%M:%S)" >>$MPSOCBENCH_INSTALLER_PATH/log/mpsocbench_installer.log
	fi
	
	echo "----------------------------------------------------"
	echo "Checking for and downloading required files in the folder $MPSOCBENCH_INSTALLER_PATH/$MPSOCBENCH_INSTALLER_FILES_TMP"
	if [[ $MPSOCBENCH_INSTALL_PAUSE == 1 ]]
	then
		read -p "Press Enter to continue" nothing
	fi

	if [ ! -d $MPSOCBENCH_INSTALLER_PATH/$MPSOCBENCH_INSTALLER_FILES_TMP ];
	then
		mkdir $MPSOCBENCH_INSTALLER_PATH/$MPSOCBENCH_INSTALLER_FILES_TMP
		if [ ! -d $MPSOCBENCH_INSTALLER_PATH/$MPSOCBENCH_INSTALLER_FILES_TMP ];
		then
			mkdir $MPSOCBENCH_INSTALLER_PATH/$MPSOCBENCH_INSTALLER_FILES_TMP
		fi
	fi

	setInstallerPermission


	cd $MPSOCBENCH_INSTALLER_PATH/$MPSOCBENCH_INSTALLER_FILES_TMP



	tmp_size=$(du -s systemc-2.3.1.tgz --bytes | cut -f1)
	if [[ $tmp_size != 7291190 ]];
	then
		rm -rf systemc-2.3.1.tgz
		wget http://www.accellera.org/images/downloads/standards/systemc/systemc-2.3.1.tgz
		if [ ! -f systemc-2.3.1.tgz ];
		then
			echo "File systemc-2.3.1.tgz does not exist, please download the file in http://www.accellera.org/downloads/standards/systemc"
			echo -e "File systemc-2.3.1.tgz does not exist, please download the file in http://www.accellera.org/downloads/standards/systemc" >>$MPSOCBENCH_INSTALLER_PATH/log/mpsocbench_installer.log
			_exit
		fi
	fi
	
	tmp_size=$(du -s ArchC-2.4.1.tar.gz --bytes | cut -f1)
	if [[ $tmp_size != 1632346 ]];
	then
		rm -rf ArchC-2.4.1.tar.gz
		wget -O ArchC-2.4.1.tar.gz https://github.com/ArchC/ArchC/archive/v2.4.1.tar.gz
		if [ ! -f ArchC-2.4.1.tar.gz ];
		then
			echo "ERROR: File ArchC-2.4.1.tar.gz does not exist, please download the file in http://www.archc.org/downloads.html"
			echo -e "ERROR: File ArchC-2.4.1.tar.gz does not exist, please download the file in http://www.archc.org/downloads.html" >>$MPSOCBENCH_INSTALLER_PATH/log/mpsocbench_installer.log
			_exit
		fi
	fi
	
	tmp_size=$(du -s MPSoCBench-2.2.tar.gz --bytes | cut -f1)
	if [[ $tmp_size != 209557474 ]];
	then
		rm -rf MPSoCBench-2.2.tar.gz
		wget -O MPSoCBench-2.2.tar.gz https://github.com/ArchC/MPSoCBench/archive/2.2.tar.gz 
		if [ ! -f MPSoCBench-2.2.tar.gz ];	
		then
			echo "File MPSoCBench-2.2.tar.gz does not exist, please download the file in https://github.com/ArchC/MPSoCBench/releases/tag/2.2 or https://github.com/ArchC/MPSoCBench/releases"
			echo -e "File MPSoCBench-2.2.tar.gz does not exist, please download the file in https://github.com/ArchC/MPSoCBench/releases/tag/2.2 or https://github.com/ArchC/MPSoCBench/releases" >>$MPSOCBENCH_INSTALLER_PATH/log/mpsocbench_installer.log
			_exit
		fi
	fi

	tmp_size=$(du -s archc_arm_toolchain_20150102_64bit.tar.bz2 --bytes | cut -f1)
	if [[ $tmp_size != 31199570 ]];
	then
		rm -rf archc_arm_toolchain_20150102_64bit.tar.bz2
		wget -O archc_arm_toolchain_20150102_64bit.tar.bz2 http://archc.lsc.ic.unicamp.br/downloads/Tools/arm/archc_arm_toolchain_20150102_64bit.tar.bz2
		if [ ! -f archc_arm_toolchain_20150102_64bit.tar.bz2 ];
		then
			echo "File archc_arm_toolchain_20150102_64bit.tar.bz2 does not exist, please download \"Cross compilers and tools\" in http://www.archc.org/downloads.html"
			echo -e "File archc_arm_toolchain_20150102_64bit.tar.bz2 does not exist, please download \"Cross compilers and tools\" in http://www.archc.org/downloads.html" >>$MPSOCBENCH_INSTALLER_PATH/log/mpsocbench_installer.log
			_exit
		fi
	fi

	tmp_size=$(du -s archc_powerpc_toolchain_20141215_64bit.tar.bz2 --bytes | cut -f1)
	if [[ $tmp_size != 24460331 ]];
	then
		rm -rf archc_powerpc_toolchain_20141215_64bit.tar.bz2
		wget -O archc_powerpc_toolchain_20141215_64bit.tar.bz2 http://archc.lsc.ic.unicamp.br/downloads/Tools/powerpc/archc_powerpc_toolchain_20141215_64bit.tar.bz2
		if [ ! -f archc_powerpc_toolchain_20141215_64bit.tar.bz2 ];
		then
			echo "File archc_powerpc_toolchain_20141215_64bit.tar.bz2 does not exist, please download \"Cross compilers and tools\" in http://www.archc.org/downloads.html"
			echo -e "File archc_powerpc_toolchain_20141215_64bit.tar.bz2 does not exist, please download \"Cross compilers and tools\" in http://www.archc.org/downloads.html" >>$MPSOCBENCH_INSTALLER_PATH/log/mpsocbench_installer.log
			_exit
		fi
	fi

	tmp_size=$(du -s archc_mips_toolchain_20141215_64bit.tar.bz2 --bytes | cut -f1)
	if [[ $tmp_size != 22939726 ]];
	then
		rm -rf archc_mips_toolchain_20141215_64bit.tar.bz2
		wget -O archc_mips_toolchain_20141215_64bit.tar.bz2 http://archc.lsc.ic.unicamp.br/downloads/Tools/mips/archc_mips_toolchain_20141215_64bit.tar.bz2
		if [ ! -f archc_mips_toolchain_20141215_64bit.tar.bz2 ];
		then
			echo "File archc_mips_toolchain_20141215_64bit.tar.bz2 does not exist, please download \"Cross compilers and tools\" in http://www.archc.org/downloads.html"
			echo -e "File archc_mips_toolchain_20141215_64bit.tar.bz2 does not exist, please download \"Cross compilers and tools\" in http://www.archc.org/downloads.html" >>$MPSOCBENCH_INSTALLER_PATH/log/mpsocbench_installer.log
			_exit
		fi
	fi

	tmp_size=$(du -s archc_sparc_toolchain_20141215_64bit.tar.bz2 --bytes | cut -f1)
	if [[ $tmp_size != 20471136 ]];
	then
		rm -rf archc_sparc_toolchain_20141215_64bit.tar.bz2
		wget -O archc_sparc_toolchain_20141215_64bit.tar.bz2 http://archc.lsc.ic.unicamp.br/downloads/Tools/sparc/archc_sparc_toolchain_20141215_64bit.tar.bz2
		if [ ! -f archc_sparc_toolchain_20141215_64bit.tar.bz2 ];
		then
			echo "File archc_sparc_toolchain_20141215_64bit.tar.bz2 does not exist, please download \"Cross compilers and tools\" in http://www.archc.org/downloads.html"
			echo -e "File archc_sparc_toolchain_20141215_64bit.tar.bz2 does not exist, please download \"Cross compilers and tools\" in http://www.archc.org/downloads.html" >>$MPSOCBENCH_INSTALLER_PATH/log/mpsocbench_installer.log
			_exit
		fi
	fi



	echo "----------------------------------------------------"
	echo "Installing dependencies $(date +%y\/%m\/%d\ \-\ %H:%M:%S)"
	echo "It can take up to about 20 min..."
	if [[ $MPSOCBENCH_INSTALL_PAUSE == 1 ]]
	then
		read -p "Press Enter to continue" nothing
	fi


	if [ $UID == $ROOT_UID ];
	then
	echo -e "Installing dependencies" >>$MPSOCBENCH_INSTALLER_PATH/log/mpsocbench_installer.log
	
		apt-get -qq update -qq
		apt-get -y -qq install gcc
		apt-get -y -qq install g++
		apt-get -y -qq install python
		apt-get -y -qq install unzip
		apt-get -y -qq install make
		apt-get -y -qq install gawk
		apt-get -y -qq install libc6-i386
		apt-get -y -qq install vim
		apt-get -y -qq install m4
		apt-get -y -qq install patch

		apt-get -y -qq install git
		apt-get -y -qq install autoconf
		apt-get -y -qq install libtool
		apt-get -y -qq install libdw-dev
		apt-get -y -qq install bison flex byacc
		apt-get -y -qq install pkg-config

		apt-get -y -qq install build-essential automake libtool
	else
		echo "Skiped instals this required softwares because don't have sudo permissions:
		apt-get update
		apt-get -y -qq install gcc
		apt-get -y -qq install g++
		apt-get -y -qq install python
		apt-get -y -qq install unzip
		apt-get -y -qq install make
		apt-get -y -qq install gawk
		apt-get -y -qq install libc6-i386
		apt-get -y -qq install vim
		apt-get -y -qq install m4
		apt-get -y -qq install patch

		apt-get -y -qq install git
		apt-get -y -qq install autoconf
		apt-get -y -qq install libtool
		apt-get -y -qq install libdw-dev
		apt-get -y -qq install bison flex byacc
		apt-get -y -qq install pkg-config

		apt-get -y -qq install build-essential automake libtool
		
		"
	fi

	echo "----------------------------------------------------"
	echo "Removing previous install, create folder tree, uncompress and copy files..."
	if [[ $MPSOCBENCH_INSTALL_PAUSE == 1 ]]
	then
		read -p "Press Enter to continue" nothing
	fi
	
	if [ ! -d $MPSOCBENCH_INSTALL_PATH ];
	then
		mkdir $MPSOCBENCH_INSTALL_PATH
	fi
	
	# Remove old version
	rm -rf $MPSOCBENCH_INSTALL_PATH/src/archc-2.4
	rm -rf $MPSOCBENCH_INSTALL_PATH/archc-2.4
	rm -rf $MPSOCBENCH_INSTALL_PATH/mpsocbench-2.1
	
	
	
	# END, remove old version
	
	
	rm -rf $MPSOCBENCH_INSTALL_PATH/src/

	mkdir $MPSOCBENCH_INSTALL_PATH/src/
	rm -rf $MPSOCBENCH_INSTALL_PATH/systemc
	rm -rf $MPSOCBENCH_INSTALL_PATH/systemc-2.3.1
	rm -rf $MPSOCBENCH_INSTALL_PATH/src/systemc-2.3.1/

	mkdir $MPSOCBENCH_INSTALL_PATH/systemc-2.3.1
	tar xf systemc-2.3.1.tgz
	mv systemc-2.3.1/ $MPSOCBENCH_INSTALL_PATH/src/systemc-2.3.1

	ln -s $MPSOCBENCH_INSTALL_PATH/systemc-2.3.1 $MPSOCBENCH_INSTALL_PATH/systemc




	rm -rf $MPSOCBENCH_INSTALL_PATH/src/archc-2.4.1
	rm -rf $MPSOCBENCH_INSTALL_PATH/archc-2.4.1
	rm -rf $MPSOCBENCH_INSTALL_PATH/archc
	mkdir $MPSOCBENCH_INSTALL_PATH/archc-2.4.1

	tar xf ArchC-2.4.1.tar.gz
	mv ArchC-2.4.1/ $MPSOCBENCH_INSTALL_PATH/src/archc-2.4.1

	ln -s $MPSOCBENCH_INSTALL_PATH/archc-2.4.1 $MPSOCBENCH_INSTALL_PATH/archc



	rm -rf $MPSOCBENCH_INSTALL_PATH/mpsocbench-2.2
	rm -rf $MPSOCBENCH_INSTALL_PATH/mpsocbench
	tar xf MPSoCBench-2.2.tar.gz
	mv MPSoCBench-2.2/ $MPSOCBENCH_INSTALL_PATH/mpsocbench-2.2

	ln -s $MPSOCBENCH_INSTALL_PATH/mpsocbench-2.2 $MPSOCBENCH_INSTALL_PATH/mpsocbench
	

	echo "----------------------------------------------------"
	echo "Installing Compilers
	
	"
	if [[ $MPSOCBENCH_INSTALL_PAUSE == 1 ]]
	then
		read -p "Press Enter to continue" nothing
	fi

	rm -rf $MPSOCBENCH_INSTALL_PATH/tools/
	if [ -d /tmp/tmp_archc_compilers/ ];
	then
		chmod 777 -R /tmp/tmp_archc_compilers/
		rm -rf /tmp/tmp_archc_compilers/
	fi
	
	mkdir /tmp/tmp_archc_compilers/

	mkdir $MPSOCBENCH_INSTALL_PATH/tools/
	mkdir $MPSOCBENCH_INSTALL_PATH/tools/compilers/





	cp archc_mips_toolchain_20141215_64bit.tar.bz2 /tmp/tmp_archc_compilers/archc_mips_toolchain_20141215_64bit.tar.bz2
	cp archc_arm_toolchain_20150102_64bit.tar.bz2 /tmp/tmp_archc_compilers/archc_arm_toolchain_20150102_64bit.tar.bz2
	cp archc_powerpc_toolchain_20141215_64bit.tar.bz2 /tmp/tmp_archc_compilers/archc_powerpc_toolchain_20141215_64bit.tar.bz2
	cp archc_sparc_toolchain_20141215_64bit.tar.bz2 /tmp/tmp_archc_compilers/archc_sparc_toolchain_20141215_64bit.tar.bz2

	if [[ $MPSOCBENCH_VAGRANT_INSTALL == 1 ]]
	then
		chown vagrant -R /tmp/tmp_archc_compilers/
		chown vagrant:vagrant -R /tmp/tmp_archc_compilers/
	fi

	chmod +x -R /tmp/tmp_archc_compilers/
	chmod 777 -R /tmp/tmp_archc_compilers/




	cd /tmp/tmp_archc_compilers/
	tar -xf archc_arm_toolchain_20150102_64bit.tar.bz2
	tar -xf archc_powerpc_toolchain_20141215_64bit.tar.bz2
	tar -xf archc_mips_toolchain_20141215_64bit.tar.bz2
	tar -xf archc_sparc_toolchain_20141215_64bit.tar.bz2


	chmod 777 -R /tmp/tmp_archc_compilers/
	mv /tmp/tmp_archc_compilers/arm-newlib-eabi $MPSOCBENCH_INSTALL_PATH/tools/compilers/arm-newlib-eabi
	mv /tmp/tmp_archc_compilers/powerpc-newlib-elf $MPSOCBENCH_INSTALL_PATH/tools/compilers/powerpc-newlib-elf
	mv /tmp/tmp_archc_compilers/mips-newlib-elf $MPSOCBENCH_INSTALL_PATH/tools/compilers/mips-newlib-elf
	mv /tmp/tmp_archc_compilers/sparc-newlib-elf $MPSOCBENCH_INSTALL_PATH/tools/compilers/sparc-newlib-elf

	cd /tmp
	
	if [ -d /tmp/tmp_archc_compilers/ ];
	then
		chmod 777 -R /tmp/tmp_archc_compilers/
		rm -rf /tmp/tmp_archc_compilers/
	fi


	echo "----------------------------------------------------"
	echo "Installing SystemC $(date +%y\/%m\/%d\ \-\ %H:%M:%S)
	
	"
	
	echo -e "\n\n\nInstalling SystemC $(date +%y\/%m\/%d\ \-\ %H:%M:%S)" >>$MPSOCBENCH_INSTALLER_PATH/log/SystemC.log
	if [[ $MPSOCBENCH_INSTALL_PAUSE == 1 ]]
	then
		read -p "Press Enter to continue" nothing
	fi

	cd $MPSOCBENCH_INSTALL_PATH/src/systemc-2.3.1
	mkdir objdir
	cd objdir
	
	echo "Running: ../configure --prefix=$MPSOCBENCH_INSTALL_PATH/systemc >>$MPSOCBENCH_INSTALLER_PATH/log/SystemC.log"
	echo "It can take up to about 20 min..."
	echo -e "\n\n----------- ../configure --prefix=$MPSOCBENCH_INSTALL_PATH/systemc -------- " >>$MPSOCBENCH_INSTALLER_PATH/log/SystemC.log
	../configure --prefix=$MPSOCBENCH_INSTALL_PATH/systemc >>$MPSOCBENCH_INSTALLER_PATH/log/SystemC.log 2>>$MPSOCBENCH_INSTALLER_PATH/log/SystemC.log
	
	echo "Running: make >>$MPSOCBENCH_INSTALLER_PATH/log/SystemC.log"
		echo "It can take up to about 20 min..."
		echo -e "\n\n----------- make -------- " >>$MPSOCBENCH_INSTALLER_PATH/log/SystemC.log
		make >>$MPSOCBENCH_INSTALLER_PATH/log/SystemC.log 2>>$MPSOCBENCH_INSTALLER_PATH/log/SystemC.log
	
	
	echo "Running: make install >>$MPSOCBENCH_INSTALLER_PATH/log/SystemC.log"
		echo "It can take up to about 20 min..."
		echo -e "\n\n----------- make install -------- " >>$MPSOCBENCH_INSTALLER_PATH/log/SystemC.log 2>>$MPSOCBENCH_INSTALLER_PATH/log/SystemC.log
		make install >>$MPSOCBENCH_INSTALLER_PATH/log/SystemC.log 2>>$MPSOCBENCH_INSTALLER_PATH/log/SystemC.log
	
	cd ..
	rm -r objdir

	if [[ ! -d $MPSOCBENCH_INSTALL_PATH/systemc/lib-linux64 ]] && [[ ! -d $MPSOCBENCH_INSTALL_PATH/systemc/lib-linux ]];
	then
		echo "Fail on install SystemC, \"$MPSOCBENCH_INSTALL_PATH/systemc/lib-linux64\" or \"$MPSOCBENCH_INSTALL_PATH/systemc/lib-linux64\" not found. You can see logs in \"$MPSOCBENCH_INSTALLER_PATH/log/\""
		_exit
	fi
	
	tmp_size=$(du -s $MPSOCBENCH_INSTALL_PATH/systemc-2.3.1 --bytes | cut -f1)
	# 23236031
	if [[ $tmp_size<2100 ]] ;
	then
		echo -e "Fail to install SystemC, folder \"$MPSOCBENCH_INSTALL_PATH/systemc-2.3.1\" is very smal, read $tmp_size, expected around 22066755 bytes. You can see logs in \"$MPSOCBENCH_INSTALLER_PATH/log/\""
		_exit
	fi



	echo "----------------------------------------------------"
	echo "Installing ArchC $(date +%y\/%m\/%d\ \-\ %H:%M:%S)"
	echo -e "\n\n\nInstalling ArchC $(date +%y\/%m\/%d\ \-\ %H:%M:%S)" >>$MPSOCBENCH_INSTALLER_PATH/log/ArchC.log
	
	if [[ $MPSOCBENCH_INSTALL_PAUSE == 1 ]]
	then
		read -p "Press Enter to continue" nothing
	fi
	cd $MPSOCBENCH_INSTALL_PATH/src/archc-2.4.1
	
	echo "Runnig: ./autogen.sh >>$MPSOCBENCH_INSTALLER_PATH/log/ArchC.log"
		echo "It can take up to about 20 min..."
		echo -e "\n\n----------- ./autogen.sh -------- " >>$MPSOCBENCH_INSTALLER_PATH/log/ArchC.log 2>>$MPSOCBENCH_INSTALLER_PATH/log/ArchC.log
		./autogen.sh >>$MPSOCBENCH_INSTALLER_PATH/log/ArchC.log 2>>$MPSOCBENCH_INSTALLER_PATH/log/ArchC.log
	
	#--disable-hlt para testar em x86
	echo "Running: ./configure --prefix=$MPSOCBENCH_INSTALL_PATH/archc --with-systemc=$MPSOCBENCH_INSTALL_PATH/systemc"
		echo "It can take up to about 20 min..."
		echo -e "\n\n----------- ./configure --prefix=$MPSOCBENCH_INSTALL_PATH/archc --with-systemc=$MPSOCBENCH_INSTALL_PATH/systemc -------- " >>$MPSOCBENCH_INSTALLER_PATH/log/ArchC.log
		./configure --prefix=$MPSOCBENCH_INSTALL_PATH/archc --with-systemc=$MPSOCBENCH_INSTALL_PATH/systemc >>$MPSOCBENCH_INSTALLER_PATH/log/ArchC.log 2>>$MPSOCBENCH_INSTALLER_PATH/log/ArchC.log
	
	
	echo "Running: make >>$MPSOCBENCH_INSTALLER_PATH/log/ArchC.log"
		echo "It can take up to about 20 min..."
		echo -e "\n\n----------- make -------- " >>$MPSOCBENCH_INSTALLER_PATH/log/ArchC.log
		make >>$MPSOCBENCH_INSTALLER_PATH/log/ArchC.log 2>>$MPSOCBENCH_INSTALLER_PATH/log/ArchC.log
	
	echo "Running: make install >>$MPSOCBENCH_INSTALLER_PATH/log/ArchC.log"
		echo "It can take up to about 20 min..."
		echo -e "\n\n----------- make install -------- " >>$MPSOCBENCH_INSTALLER_PATH/log/ArchC.log
		make install >>$MPSOCBENCH_INSTALLER_PATH/log/ArchC.log 2>>$MPSOCBENCH_INSTALLER_PATH/log/ArchC.log
	
	# cd $MPSOCBENCH_INSTALL_PATH/archc
	chmod +x ./env.sh
	#./env.sh
	#bash -l




	tmp_size=$(du -s $MPSOCBENCH_INSTALL_PATH/archc-2.4.1/ --bytes | cut -f1)
	# 27675272
	if [[ $tmp_size<220 ]] ;
	then
		echo -e "Fail to install ArchC, folder \"$MPSOCBENCH_INSTALL_PATH/archc-2.4.1/\" is very small, read $tmp_size, expected around 27675272 bytes.  You can see logs in \"$MPSOCBENCH_INSTALLER_PATH/log/\""
		_exit
	fi


	echo "----------------------------------------------------"
	echo "Installing MPSocBench $(date +%y\/%m\/%d\ \-\ %H:%M:%S)"
	
	echo -e "\n\n\nInstalling MPSocBench $(date +%y\/%m\/%d\ \-\ %H:%M:%S)" >>$MPSOCBENCH_INSTALLER_PATH/log/MPSoCBench.log
	
	if [[ $MPSOCBENCH_INSTALL_PAUSE == 1 ]]
	then
		read -p "Press Enter to continue" nothing
	fi

	cd $MPSOCBENCH_INSTALL_PATH/mpsocbench

	echo "Getting processors"
	echo "It can take up to about 20 min..."
	
	rm processors -r
	git init
	git submodule add https://github.com/ArchC/mips.git processors/mips
	git submodule add https://github.com/ArchC/sparc.git processors/sparc
	git submodule add https://github.com/ArchC/powerpc.git processors/powerpc
	git submodule add https://github.com/ArchC/arm.git processors/arm

	cd $MPSOCBENCH_INSTALL_PATH/mpsocbench
	
	echo "Running: ./setup.sh $MPSOCBENCH_INSTALL_PATH/archc >>$MPSOCBENCH_INSTALLER_PATH/log/MPSoCBench.log"
		echo "It can take up to about 20 min..."
		echo -e "\n----------- ./setup.sh $MPSOCBENCH_INSTALL_PATH/archc -------- " >>$MPSOCBENCH_INSTALLER_PATH/log/MPSoCBench.log
		./setup.sh $MPSOCBENCH_INSTALL_PATH/archc >>$MPSOCBENCH_INSTALLER_PATH/log/MPSoCBench.log 2>>$MPSOCBENCH_INSTALLER_PATH/log/MPSoCBench.log

	chmod +x ./env.sh
	#source ./env.sh

	# Não sei onde é utilizado esse Makefile.conf
	if [ -d $MPSOCBENCH_INSTALL_PATH/systemc/lib-linux64 ];
	then
		echo -e "export SYSTEMC:=$MPSOCBENCH_INSTALL_PATH/systemc\nexport TLM_PATH:=$MPSOCBENCH_INSTALL_PATH/systemc/include\nexport ARCHC_PATH:=$MPSOCBENCH_INSTALL_PATH/archc\nexport ARP:=\$(PWD)\nexport PATH:=$MPSOCBENCH_INSTALL_PATH/tools/compilers/mips-newlib-elf/bin:$MPSOCBENCH_INSTALL_PATH/tools/compilers/arm-newlib-eabi/bin:$MPSOCBENCH_INSTALL_PATH/tools/compilers/powerpc-newlib-elf/bin:$MPSOCBENCH_INSTALL_PATH/tools/compilers/sparc-newlib-elf/bin:$MPSOCBENCH_INSTALL_PATH/systemc/bin:\$(PATH)\nexport HOST_OS:=linux64\nexport LD_LIBRARY_PATH:=$MPSOCBENCH_INSTALL_PATH/systemc/lib-linux64:\$(LD_LIBRARY_PATH)\nPKG_CONFIG_PATH:=$MPSOCBENCH_INSTALL_PATH/systemc/lib-linux64/pkgconfig:\$(PKG_CONFIG_PATH)" > Makefile.conf

	elif [ -d $MPSOCBENCH_INSTALL_PATH/systemc/lib-linux ];
		then
			echo -e "export SYSTEMC:=$MPSOCBENCH_INSTALL_PATH/systemc\nexport TLM_PATH:=$MPSOCBENCH_INSTALL_PATH/systemc/include\nexport ARCHC_PATH:=$MPSOCBENCH_INSTALL_PATH/archc\nexport ARP:=\$(PWD)\nexport PATH:=$MPSOCBENCH_INSTALL_PATH/tools/compilers/mips-newlib-elf/bin:$MPSOCBENCH_INSTALL_PATH/tools/compilers/arm-newlib-eabi/bin:$MPSOCBENCH_INSTALL_PATH/tools/compilers/powerpc-newlib-elf/bin:$MPSOCBENCH_INSTALL_PATH/tools/compilers/sparc-newlib-elf/bin:$MPSOCBENCH_INSTALL_PATH/systemc/bin:\$(PATH)\nexport HOST_OS:=linux\nexport LD_LIBRARY_PATH:=$MPSOCBENCH_INSTALL_PATH/systemc/lib-linux:\$(LD_LIBRARY_PATH)\nPKG_CONFIG_PATH:=$MPSOCBENCH_INSTALL_PATH/systemc/lib-linux/pkgconfig:\$(PKG_CONFIG_PATH)" > Makefile.conf
	
	else
		echo "Fail Install SystemC, $MPSOCBENCH_INSTALL_PATH/systemc/lib-linux64 or $MPSOCBENCH_INSTALL_PATH/systemc/lib-linux NOT FOUND"
		echo -e "Fail Install SystemC, $MPSOCBENCH_INSTALL_PATH/systemc/lib-linux64 or $MPSOCBENCH_INSTALL_PATH/systemc/lib-linux NOT FOUND" >>$MPSOCBENCH_INSTALLER_PATH/log/SystemC.log
		_exit
	fi


	chmod +x Makefile.conf



	if [ ! -f $MPSOCBENCH_INSTALL_PATH/mpsocbench/env.sh ];
	then
		echo -e "Fail to install MPSocBench, file \"$MPSOCBENCH_INSTALL_PATH/mpsocbench/env.sh\" not exist!"
		echo -e "Fail to install MPSocBench, file \"$MPSOCBENCH_INSTALL_PATH/mpsocbench/env.sh\" not exist!" >>$MPSOCBENCH_INSTALLER_PATH/log/MPSoCBench.log
		_exit
	fi


	tmp_size=$(du -s $MPSOCBENCH_INSTALL_PATH/mpsocbench/ --bytes | cut -f1)
	#2.1 
	# antes de instalar 260290030
	# apos instalar     260290459
	if [[ $tmp_size<2400 ]];
	then
		echo -e "Folder \"$MPSOCBENCH_INSTALL_PATH/mpsocbench/\" is very small, read $tmp_size, expected around 260290459 bytes!"
		echo -e "Folder \"$MPSOCBENCH_INSTALL_PATH/mpsocbench/\" is very small, read $tmp_size, expected around 260290459 bytes!" >>$MPSOCBENCH_INSTALLER_PATH/log/MPSoCBench.log
		_exit
	fi

# function to set enviroment


	serverfcm

	enviroment


	# Permission to Run and Build whithout sudo
	chmod 777 -R $MPSOCBENCH_INSTALL_PATH/mpsocbench
	chmod 777 -R $MPSOCBENCH_INSTALL_PATH/archc
	chmod 777 -R $MPSOCBENCH_INSTALL_PATH/systemc
	chmod 777 -R $MPSOCBENCH_INSTALL_PATH/tools
	chmod 777 -R $MPSOCBENCH_INSTALL_PATH/serverfcm
	chmod 777 -R $MPSOCBENCH_INSTALL_PATH/src

}






 # Fim das funcoes



if [[ $MPSOCBENCH_VAGRANT_HELP == 1 ]]
then
	vagrantHelp
fi





if [[ $MPSOCBENCH_CREATE_VAGRANT_FILE == 1 ]]
then
	copyCreateFiles
	
	echo "
	Files to vagrant create and copy to $MPSOCBENCH_INSTALLER_PATH
	"
	vagrantHelp
fi



if [[ $MPSOCBENCH_ENVIROMENT == 1 ]]
then
	echo "
	Enviroment of MPSocBench 2.2
	
	If you have permission, Environment Variables related to SystemC, ArchC, MPSocBench 2.2 will be added to \"/etc/profile.d\"
	Using the path= \"$MPSOCBENCH_INSTALL_PATH\"
	
	"
	isSudo
	
	if [[ $MPSOCBENCH_VAGRANT_INSTALL == 0 ]]
	then
		read -p "Do you want continue? (y/n)" -n 1 -r
		if [[ ! $REPLY =~ ^[Yy]$ ]]
		then
			echo "
			Operation canceled by user
			"
			exit
		fi
	fi

	enviroment
fi



if [[ $MPSOCBENCH_INSTALL == 1 ]]
then
	echo "
	Install MPSocBench 2.2
	
	The installation will create the folder $MPSOCBENCH_INSTALLER_PATH which has another folder with files for installation MPSocBench and some dependencies

	
	The following programs will be installed on folder \"$MPSOCBENCH_INSTALL_PATH/\":
		$MPSOCBENCH_STRING_VERSION
		$MPSOCBENCH_INSTALL_PATH/tools/(...)
		If don't exist the \"Installer\" of that, automatically will download that to \"$MPSOCBENCH_INSTALLER_PATH/$MPSOCBENCH_INSTALLER_FILES_TMP\"
		
	Environment variables related to SystemC, ArchC, MPSocBench 2.2 will be added to \"/etc/profile.d\"

	
	
	"
	isSudo
	
	if [[ $MPSOCBENCH_VAGRANT_INSTALL == 0 ]]
	then
		read -p "Do you want MPSocBench 2.2 e dependences? (y/n)" -n 1 -r
		if [[ ! $REPLY =~ ^[Yy]$ ]]
		then
			echo "
			Install canceled by user
			"
			exit
		fi
	fi

	copyCreateFiles
	mpsocbenchInstall
	
fi


if [[ $MPSOCBENCH_S_VERSION == 1 ]]
then
	echo $MPSOCBENCH_STRING_VERSION
fi


if [[ $MPSOCBENCH_CLEAR == 1 ]]
then
	isSudo
	rm -rf $MPSOCBENCH_INSTALLER_PATH/$MPSOCBENCH_INSTALLER_FILES_TMP

fi



if [[ $MPSOCBENCH_SIMPLE_TEST == 1 ]]
then
	#isSudo
	echo -e "
	Run MPSocBench \"./MPSoCBench -p=mips -pw -s=dijkstra -i=router.lt -n=4 -r\"
	
	"
	cd $MPSOCBENCH_INSTALL_PATH/mpsocbench
	
	#source env.sh
	./MPSoCBench -p=mips -pw -s=dijkstra -i=router.lt -n=4 -b
	./MPSoCBench -p=mips -pw -s=dijkstra -i=router.lt -n=4 -r

fi


if [[ $MPSOCBENCH_UNINSTALL == 1 ]]
then
	isSudo
	echo "
	
	
	Do you want Uninstall: MPSocBench 2.2, ArchC 2.4.1, SystemC 2.3.1, ServerFcm 0.2
	This folders/files will be removed:
	$MPSOCBENCH_INSTALL_PATH/src/archc-2.4
	$MPSOCBENCH_INSTALL_PATH/archc-2.4
	$MPSOCBENCH_INSTALL_PATH/mpsocbench-2.1
	$MPSOCBENCH_INSTALL_PATH/serverfcm-0.1
	/etc/sudoers.d/mpsocbench_sudoers


	/etc/profile.d/mpsocbench_env.sh
	~/.profile/mpsocbench_env.sh
	
	$MPSOCBENCH_INSTALL_PATH/src/archc-2.4.1
	$MPSOCBENCH_INSTALL_PATH/archc-2.4.1
	$MPSOCBENCH_INSTALL_PATH/archc
	
	$MPSOCBENCH_INSTALL_PATH/systemc
	$MPSOCBENCH_INSTALL_PATH/systemc-2.3.1
	$MPSOCBENCH_INSTALL_PATH/src/systemc-2.3.1/
	
	$MPSOCBENCH_INSTALL_PATH/mpsocbench-2.2
	$MPSOCBENCH_INSTALL_PATH/mpsocbench
	$MPSOCBENCH_INSTALL_PATH/tools/compilers/
	
	$MPSOCBENCH_INSTALL_PATH/serverfcm-0.2
	$MPSOCBENCH_INSTALL_PATH/serverfcm
	
	
	
	
	Do you want Uninstall: MPSocBench 2.2, ArchC 2.4.1, SystemC 2.3.1, ServerFcm 0.2
	
	"
	read -p "From Path \"$MPSOCBENCH_INSTALL_PATH\" ? (y/n)" -n 1 -r
	if [[ ! $REPLY =~ ^[Yy]$ ]]
	then
		echo "

Uninstall canceled by User
		
"
		exit
	fi
	
	# remove old version
	rm -rf $MPSOCBENCH_INSTALL_PATH/src/archc-2.4
	rm -rf $MPSOCBENCH_INSTALL_PATH/archc-2.4
	rm -rf $MPSOCBENCH_INSTALL_PATH/mpsocbench-2.1
	rm -rf $MPSOCBENCH_INSTALL_PATH/serverfcm-0.1
	rm -rf /etc/sudoers.d/mpsocbench_sudoers
	
	# end remove old version
	
	
	
	rm -rf /etc/profile.d/mpsocbench_env.sh
	rm -rf ~/.profile/mpsocbench_env.sh

	# To remove file of instaler 0.1.0

	
	rm -rf $MPSOCBENCH_INSTALL_PATH/src/archc-2.4.1
	rm -rf $MPSOCBENCH_INSTALL_PATH/archc-2.4.1
	rm -rf $MPSOCBENCH_INSTALL_PATH/archc
	
	rm -rf $MPSOCBENCH_INSTALL_PATH/systemc
	rm -rf $MPSOCBENCH_INSTALL_PATH/systemc-2.3.1
	rm -rf $MPSOCBENCH_INSTALL_PATH/src/systemc-2.3.1/
	
	
	rm -rf $MPSOCBENCH_INSTALL_PATH/mpsocbench-2.2
	rm -rf $MPSOCBENCH_INSTALL_PATH/mpsocbench
	rm -rf $MPSOCBENCH_INSTALL_PATH/tools/compilers/
	
	rm -rf $MPSOCBENCH_INSTALL_PATH/serverfcm-0.2
	rm -rf $MPSOCBENCH_INSTALL_PATH/serverfcm

	echo "

Uninstall completed!

"
	
fi



	

