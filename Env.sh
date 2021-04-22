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

#Read input
function input (){
echo "Introduce-ti \"1\" daca exercitiul acum incepe sau \"2\" daca s-a terminat "
read stage
}

#FUNCTIONS
#Start pt ununtu
function ubuntustart(){
	mkdir $arh
	cp $confu $arh 2>/dev/null
	rm $confu 2>/dev/null
	sudo apt-get -y -qq install wget 
	wget -nc -P /etc/apache2 'https://github.com/SebastianDorobantu/Linux/blob/master/apache2.conf'
	mv /var/www/html/* $arh 2>/dev/null
}


#Stop pt ubuntu
function ubuntustop(){
	rm $confu 2>/dev/null
	mv $arh/apache2.conf $confu
	mv $arh/* /var/www/html/ 2>/dev/null
	rm -r $arh

}


#Start on centos
function ubuntustart(){
	mkdir $arh
	cp $confc $arh 2>/dev/null
	rm $confc 2>/dev/null
	sudo apt-get -y -qq install wget 
	wget -nc -P /etc/httpd/conf/ 'https://github.com/SebastianDorobantu/Linux/blob/master/httpd.conf'
	mv /var/www/html/* $arh 2>/dev/null
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
	echo $os
fi
