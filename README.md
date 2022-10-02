# Local Testing Lab Setup And Run Script
 
This Bash script file manage testing lab using docker and hosts aliase.

Made for Kali linux and Parrot OS, but should work fine with pretty much any linux distro.

### Available testing labs

* bWAPP
* WebGoat 8.1
* Damn Vulnerable Web App
* OWASP Juice Shop
* WPScan Vulnerable Wordpress
* Altoro Mutual



### Get started 

Using any of these apps can be done in 3 quick and simple steps.

#### 1) Clone the repo
Clone this repo, or download it any way you prefer
```
git clone https://github.com/itsdhirajarya/Testing-Labsetup.git
cd Testing-Labsetup
```

#### 2) Install docker
Install docker using apt, like this: 
```
sudo apt install docker.io
```

For any other distro, use the prefered way to install docker.


#### 3) Start an app on localhost
Now you can start and stop one or more of these apps on your system.

```
./labsetup.sh start bwapp
```
This will download the docker, add bwapp to hosts file and run the docker
mapped to one of the localhost IPs.
That means you can just point your browser to http://bwapp and it will be up
and running.


#### 4) Stop any app
To stop any app use the stop command
```
./labsetup.sh stop dvwa
```

#### 5) List all available apps


```
./labsetup.sh list 
```

#### 6) Print help info
```
./labsetup.sh 
```


### Usage
```

Usage: ./labsetup.sh {list|start|stop} [projectname]

 This scripts uses docker and hosts alias to make web apps available on localhost"

Ex.
./labsetup.sh list
   List all available projects  

./labsetup.sh start bwapp
   Start docker container with bwapp and make it available on localhost  

./labsetup.sh stop dvwa
   Stop docker container

```

 ### Dockerfiles from
 DVWA                   - Ryan Dewhurst (vulnerables/web-dvwa)  

 bWapp                  - Rory McCune (raesene/bwapp)  

 Webgoat81             - OWASP Project  Webgoat 8.1

 Juice Shop             - OWASP Project (bkimminich/juice-shop)  

 Vulnerable Wordpress   - github.com/wpscanteam/VulnerableWordpress  

 Altoro Mutual          - github.com/hclproducts/altoroj  





## Note:

```
$ This script file using run multiple testing lab apps in same time.

$ This script file all apps start different ips and ports
```



 ### Auther details:


 * Name: Dhiraj Arya
 * Location: Patna Bihar
 * Gmail: thecyberarya@gmail.com / dhirajarya.ptn@gmail.com
 * Github: https://github.com/itsdhirajarya
 * Instagram: https://www.instagram.com/thecyberarya
 * Twitter: https://twitter.com/thecyberarya
 * Website: https://thecyberarya.blogspot.com/
 * Youtube: https://www.youtube.com/channel/UC5Pb5ZmApNR3VBQefT2A0LA