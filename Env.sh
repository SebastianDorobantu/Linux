#!/bin/bash

#Privilage check
if [ "$EUID" -ne 0 ]
then echo "Please run as root"
	exit
fi


#SETUP


#VARIABLES
html=/var/www/html
confu=/etc/apache2/apache2.conf
confc=/etc/httpd/conf/httpd.conf
os=$(cat /etc/*release |grep 'ubuntu')
arh=/var/Seb
Updatevar="\e\n \e[1m\e[31mSTARTING \e[1mSYSTEM \e[1mUPDATE\e[0m \e\n"
Envar="\e\n \e[31m\e[1mINITIALIZING \e[1mENVIROMENT\e[0m \e\n"
Compvar="\e\n \e[31m\e[1mENVIROMENT \e[1mINITIALIZED\e[0m \e\n"
Restvar="\e\n \e[31m\e[1mENVIROMENT \e[1mRESTORE\e[0m \e\n"
Apache="\e\n \e[31mCHECKING AND INSTALLING APACHE RESTORE\e[0m \e\n"

#Read input
function input (){
echo "Introduce-ti \"1\" daca exercitiul acum incepe sau \"2\" daca s-a terminat "
read stage
}

#FUNCTIONS
#Start pt ununtu
function ubuntustart(){
	echo -e $Updatevar
	sudo apt-get -y update;sudo apt-get -y upgrade
	sudo apt-get -y -qq install wget
    echo -e $Apache
    sudo apt-get -y install apache2
    systemctl start apache2
    systemctl enable apache2

	echo -e $Envar
	mkdir $arh
	cp $confu $arh 2>/dev/null
	rm $confu 2>/dev/null
	wget -nc -P /etc/apache2 'https://github.com/SebastianDorobantu/Linux/blob/master/apache2.conf'
	mv /var/www/html/* $arh 2>/dev/null
	echo -e $Compvar
}


#Stop pt ubuntu
function ubuntustop(){
	rm $confu 2>/dev/null
	mv $arh/apache2.conf $confu
	mv $arh/* /var/www/html/ 2>/dev/null
	rm -r $arh
	echo -e "$Restvar"
}


#Start on centos
function centosstart(){
	echo -e $Updatevar
	sudo yum -y update;sudo yum -y upgrade
	sudo yum -q -y nstall wget
    echo -e $Apache
    yum -y install httpd
    systemctl start httpd
    systemctl enable httpd

	echo -e $Envar
	mkdir $arh
	cp $confc $arh 2>/dev/null
	rm $confc 2>/dev/null
	wget -nc -P /etc/httpd/conf/ 'https://github.com/SebastianDorobantu/Linux/blob/master/httpd.conf'
	mv /var/www/html/* $arh 2>/dev/null
	echo -e $Compvar
}

#Stop pt centos
function centosstop(){
	rm $confc 2>/dev/null
	mv $arh/httpd.conf $confc
	mv $arh/* /var/www/html/ 2>/dev/null
	rm -r $arh
	echo -e $Restvar
}





#EXECUTION

#Get input
while [[ $stage -ne '1' ]] &&  [[ $stage -ne '2' ]]
do
	input
done


#Function redirection
if [[ $os != '' ]]; then
	if [[ $stage -eq '1' ]]
	then
		ubuntustart
	else
		ubuntustop
	fi
else
	if [[ $stage -eq '1' ]]
	then
		centosstart
	else
		centosstop
	fi
fi
