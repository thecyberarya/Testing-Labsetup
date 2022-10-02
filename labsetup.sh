#!/bin/bash

################################################################################################
echo "
.____          ___.       _________       __                
|    |   _____ \_ |__    /   _____/ _____/  |_ __ ________  
|    |   \__  \ | __ \   \_____  \_/ __ \   __\  |  \____ \ 
|    |___ / __ \| \_\ \  /        \  ___/|  | |  |  /  |_> >
|_______ (____  /___  / /_______  /\___  >__| |____/|   __/ 
        \/    \/    \/          \/     \/           |__|    
Auther: Dhiraj Arya
Github: https://github.com/itsdhirajarya/
Website: https://thecyberarya.blogspot.com/
"
################################################################################################



ETC_HOSTS=/etc/hosts

############ The command line help ###############

display_help() {
    echo "Local PentestLab Management Script (Docker based)"
    echo
    echo "Usage: $0 {list|start|stop} [projectname]" >&2
    echo
    echo " This scripts uses docker and hosts alias to make web apps available on localhost"
    echo 
    echo " Ex."
    echo " $0 list"
    echo " 	List all available projects"
    echo " $0 status"
    echo "	Show status for all projects"
    echo " $0 start bwapp"
    echo " 	Start project and make it available on localhost" 
    echo " $0 info bwapp"
    echo " 	Show information about bwapp proejct"
    echo
    echo " Dockerfiles from:"
    echo "  DVWA                   - Ryan Dewhurst (vulnerables/web-dvwa)"
    echo "  bWapp                  - Rory McCune (raesene/bwapp)"
    echo "  Webgoat81             - OWASP Project Webgoat 8.1"
    echo "  Juice Shop             - OWASP Project (bkimminich/juice-shop)"
    echo "  Vulnerable Wordpress   - Custom made from github.com/wpscanteam/VulnerableWordpress"
    echo "  Altoro Mutual          - Custom made from github.com/hclproducts/altoroj"

    exit 1
}

############### Check if docker is installed and running ##################

if ! [ -x "$(command -v docker)" ]; then
  echo 
  echo "Docker was not found. Please install docker before running this script."
  echo "For kali linux you can install docker with the following command:"
  echo "  apt install docker.io"
  exit
fi

if sudo service docker status | grep inactive > /dev/null
then 
	echo "Docker is not running."
	echo -n "Do you want to start docker now (y/n)?"
	read answer
	if echo "$answer" | grep -iq "^y"; then
		sudo service docker start
	else
		echo "Not starting. Script will not be able to run applications."
	fi
fi



############# List all pentest apps ##############

list() {
    echo "Available pentest applications" >&2
    echo "  bwapp 		- bWAPP PHP/MySQL based from itsecgames.com"
    echo "  webgoat81		- OWASP WebGoat 8.1"
    echo "  dvwa     		- Damn Vulnerable Web Application"
    echo "  juiceshop		- OWASP Juice Shop"
    echo "  vulnerablewordpress	- WPScan Vulnerable Wordpress"
    echo "  altoro		- Altoro Mutual Vulnerable Bank"

#    echo "  securitysheperd	- OWASP Security Sheperd"
    echo
    exit 1

}

#############   hosts file util    ##############

function removehost() {
    if [ -n "$(grep $1 /etc/hosts)" ]
    then
        echo "Removing $1 from $ETC_HOSTS";
        sudo sed -i".bak" "/$1/d" $ETC_HOSTS
    else
        echo "$1 was not found in your $ETC_HOSTS";
    fi
}

function addhost() { # ex.   127.5.0.1	bwapp
    HOSTS_LINE="$1\t$2"
    if [ -n "$(grep $2 /etc/hosts)" ]
        then
            echo "$2 already exists in /etc/hosts"
        else
            echo "Adding $2 to your $ETC_HOSTS";
            sudo -- sh -c -e "echo '$HOSTS_LINE' >> /etc/hosts";

            if [ -n "$(grep $2 /etc/hosts)" ]
                then
                    echo -e "$HOSTS_LINE was added succesfully to /etc/hosts";
                else
                    echo "Failed to Add $2, Try again!";
            fi
    fi
}

############ Labs Start #############

project_start ()
{
  fullname=$1		# ex. WebGoat 7.1
  projectname=$2     	# ex. webgoat7
  dockername=$3  	# ex. raesene/bwapp
  ip=$4   		# ex. 127.5.0.1
  port=$5		# ex. 80
  port2=$6		# optional override port (if app doesn't support portmapping)
  
  echo "Starting $fullname"
  addhost "$ip" "$projectname"

  if [ "$(sudo docker ps -aq -f name=^/$projectname$)" ]; 
  then
    echo "Running command: docker start $projectname"
    sudo docker start $projectname
  else
    if [ -n "${6+set}" ]; then
      echo "Running command: docker run --name $projectname -d -p $ip:80:$port -p $ip:$port2:$port2 $dockername"
      sudo docker run --name $projectname -d -p $ip:80:$port -p $ip:$port2:$port2 $dockername
    else echo "not set";
      echo "Running command: docker run --name $projectname -d -p $ip:80:$port $dockername"
      sudo docker run --name $projectname -d -p $ip:80:$port $dockername
    fi
  fi
  echo "DONE!"
  echo
  echo "Docker mapped to http://$projectname or http://$ip"
  echo
}


############ Labs Stop #############

project_stop ()
{
  fullname=$1	# ex. WebGoat 7.1
  projectname=$2     # ex. webgoat7

  if [ "$(sudo docker ps -q -f name=^/$projectname$)" ]; 
  then
    echo "Stopping... $fullname"
    echo "Running command: docker stop $projectname"
    sudo docker stop $projectname
    removehost "$projectname"
  fi

}


#############   Lab Stop and Config   ##############

project_start_dispatch()
{
  case "$1" in
    bwapp)
      project_start "bWAPP" "bwapp" "raesene/bwapp" "127.5.0.1" "80"
      project_startinfo_bwapp
    ;;   
    webgoat81)
      project_start "WebGoat 8.1" "webgoat81" "webgoat/goatandwolf" "127.17.0.1" "8080"
      project_startinfo_webgoat81
    ;;    
    dvwa)
      project_start "Damn Vulnerable Web Appliaction" "dvwa" "vulnerables/web-dvwa" "127.8.0.1" "80"
      project_startinfo_dvwa
    ;;    
    juiceshop)
      project_start "OWASP Juice Shop" "juiceshop" "bkimminich/juice-shop" "127.10.0.1" "3000"
      project_startinfo_juiceshop
    ;;
    vulnerablewordpress)
      project_start "WPScan Vulnerable Wordpress" "vulnerablewordpress" "eystsen/vulnerablewordpress" "127.12.0.1" "80" "3306"
      project_startinfo_vulnerablewordpress
    ;;
    altoro)    
      project_start "Altoro Mutual" "altoro" "eystsen/altoro" "127.14.0.1" "8080"
      project_startinfo_altoro
    ;;
    *)
    echo "ERROR: Project start dispatch doesn't recognize the project name $1" 
    ;;
  esac  
}

#############   Lab Stop and Config   ##############

project_stop_dispatch()
{
  case "$1" in
    bwapp)
      project_stop "bWAPP" "bwapp"
    ;;
    webgoat81)
      project_stop "WebGoat 8.1" "webgoat81"
    ;;
    dvwa)
      project_stop "Damn Vulnerable Web Appliaction" "dvwa"
    ;;
    juiceshop)
      project_stop "OWASP Juice Shop" "juiceshop"
    ;;
    vulnerablewordpress)
      project_stop "WPScan Vulnerable Wordpress" "vulnerablewordpress"
    ;;
    altoro)
      project_stop "Altoro Mutual" "altoro"
    ;;
    *)
    echo "ERROR: Project stop dispatch doesn't recognize the project name $1" 
    ;;
  esac  
}


#############   Main switch case   ##############

  case "$1" in
    start)
      if [ -z "$2" ]
      then
    	echo "ERROR: Option start needs project name in lowercase"
        echo 
        list # call list ()
        break
      fi
      project_start_dispatch $2
      ;;
    startpublic)
      if [ -z "$2" ]
      then
    	echo "ERROR: Option start needs project name in lowercase"
        echo 
        list # call list ()
        break
      fi

      if [ -z "$4" ]
      then
        port=80
      else
        port=$4
      fi


      if [ "$3" ]
      then
        publicip=$3
      else
      	publicip=`hostname -I | cut -d" " -f1`
    
	echo "Continue using local IP address $publicip?"
        select yn in "Yes" "No"; do
          case $yn in
            Yes )  
              break;;
            No ) 
              echo "Specify the correct IP address.";  
              echo " ex."; 
              echo "   $0 startpublic bwapp 192.168.0.105"; 
              exit;;
          esac
        done
      fi

      listen="$publicip:$port"
      if [ "$(netstat -ln4 | grep -w $listen )" ]
      then
        echo "$publicip already listening on port $port"
        echo "Free up the port or select a different port to bind $2"
        exit
      fi

      project_startpublic_dispatch $2 $publicip $port
      echo "WARNING! Only do this in trusted lab environment. WARNING!"
      echo "WARNING! Anyone with nettwork access can now pwn this machine! WARNING!" 
      ;;
    stop)
      if [ -z "$2" ]
      then
    	echo "ERROR: Option start needs project name in lowercase"
        echo 
        list # call list ()
        break
      fi
      project_stop_dispatch $2
      ;;
    list)
      list # call list ()
      ;;
    status)
      project_status # call project_status ()
      ;;
    info)
      if [ -z "$2" ]
      then
    	echo "ERROR: Option start needs project name in lowercase"
        echo 
        list # call list ()
        break
      fi
      info $2
      ;;
    *)
      display_help
      ;;
  esac  
 

