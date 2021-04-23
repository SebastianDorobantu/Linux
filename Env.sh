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
user=$(users)

Updatevar="\e\n \e[1m\e[31mSTARTING \e[1mSYSTEM \e[1mUPDATE\e[0m \e\n"
Envar="\e\n \e[31m\e[7mINITIALIZING \e[7mENVIROMENT\e[0m \e\n"
Compvar="\e\n \e[31m\e[6mENVIROMENT \e[6mINITIALIZED\e[0m \e\n"
Restvar="\e\n  \e\n \e[31m\e[7mENVIROMENT \e[7mRESTORED\e[0m \e\n"
Apache="\e\n \e[31mCHECKING AND INSTALLING APACHE\e[0m \e\n"
Files="\e\n \e[31mGETTING SOME EXTRA FILES\e[0m \e\n"




#Read input
function input (){
echo "++= Introduce-ti \"1\" daca exercitiul acum incepe sau \"2\" daca s-a terminat =++"
echo "||                                                                          ||"
echo "++==================================++======================================++"
echo "                                    ||"
echo "                                   \||/"
echo "                                    \/"
read -p "                                    " stage
}

#FUNCTIONS
#Start pt ununtu
function ubuntustart(){
	echo -e $Updatevar
	sleep 1
	sudapt-get -y update;sudo apt-get -y upgrade
	sudo apt-get -y -qq install wget
	echo -e $Apache
	sleep 1
	sudo apt-get -y install apache2
   	systemctl start apache2
	systemctl enable apache2

	echo -e $Envar
	sleep 2
	mkdir $arh
	cp $confu $arh 2>/dev/null
	rm $confu 2>/dev/null
	wget -nc -P /etc/apache2 'https://github.com/SebastianDorobantu/Linux/blob/master/apache2.conf'
	mv /var/www/html/* $arh 2>/dev/null
}


#Stop pt ubuntu
function ubuntustop(){
	rm $confu 2>/dev/null
	mv $arh/apache2.conf $confu 2>/dev/null
	mv $arh/* /var/www/html/ 2>/dev/null
	rm -r $arh 2>/dev/null
	sleep 1
}


#Start on centos
function centosstart(){
	echo -e $Updatevar
	sleep 1
	sudo yum -y update;sudo yum -y upgrade
	sudo yum -q -y install wget
	echo -e $Apache
	sleep 1
	yum -y install httpd
	systemctl start httpd
	systemctl enable httpd

	echo -e $Envar
	sleep 1
	mkdir $arh
	cp $confc $arh 2>/dev/null
	rm $confc 2>/dev/null
	wget -nc -P /etc/httpd/conf/ 'https://github.com/SebastianDorobantu/Linux/blob/master/httpd.conf'
	mv /var/www/html/* $arh 2>/dev/null
	sleep 1
}

#Stop pt centos
function centosstop(){
	rm $confc 2>/dev/null
	mv $arh/httpd.conf $confc 2>/dev/null
	mv $arh/* /var/www/html/ 2>/dev/null
	rm -r $arh 2>/dev/null
	sleep 1
}

#Files in HOME
function files(){
	echo -e $Files
	sleep 1
	mkdir /home/$user/Recapitulare 2>/dev/null
	mkdir /home/$user/Recapitulare/Animale 2>/dev/null
	wget -nc -P /home/$user/Recapitulare/Animale "https://github.com/SebastianDorobantu/Linux/blob/master/Pisica.jpg"
	wget -nc -P /home/$user/Recapitulare/Animale "https://github.com/SebastianDorobantu/Linux/blob/master/Caine.jpg"
	wget -nc -P /home/$user/Recapitulare/Animale "https://github.com/SebastianDorobantu/Linux/blob/master/Veverita.jpg"
	wget -nc -P /home/$user/Recapitulare "https://github.com/SebastianDorobantu/Linux/blob/master/Recapitulare.docx"
	echo -e $Compvar
	sleep 2
}


function nofiles(){
	rm -r /home/$user/Recapitulare/ 2> /dev/null


	echo
	echo -ne '                                  (0%)\r'
	sleep 0.2
	echo -ne '###########                      (33%)\r'
	sleep 0.3
	echo -ne '###############                  (45%)\r'
	sleep 0.4
	echo -ne '#####################            (60%)\r'
	sleep 0.5
	echo -ne '########################         (70%)\r'
	sleep 0.2
	echo -ne '##############################   (87%)\r'
	sleep 0.4
	echo -ne '#################################(100%)\r'
	sleep 0.3

	echo -e "$Restvar"
	sleep 2
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
		files
	else
		ubuntustop
		nofiles
	fi
else
	if [[ $stage -eq '1' ]]
	then
		centosstart
		nofiles
	else
		centosstop
		nofiles
	fi
fi
