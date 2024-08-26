#!/bin/bash

##WRITTEN BY E FOR STRONGSWAN INSTALLATION AND CONFIGURATION
##EXTRA STEPS NEEDED ARE TO MANUALLY ADD CONFIGURATION FILES FOR THE CONNECTIONS BEFORE RUNNING THE SCRIPT

##FUTURE FEATURE ARE TO INCLUDE SUSE AND RHEL INSTALLATIONS


mint=Linuxmint
debian=Debian
ubuntu=Ubuntu
suse=SUSE

main(){
    variable_init
    check_distro
    #debug
}

variable_init(){ #INITALIZES THE VARIABLES NEEDED FOR FILE CONFIGURATION
    echo "Please type in username: "
    read username
    echo "Please type in password: "
    read -s password
    echo "Please type in PSK: "
    read -s pw_secret
    #echo "Please type alternative PSK"
    #read -s pw_secret_2
}

check_distro(){
distro=$(lsb_release -is | cut -f 2-) #PRINTS OUT DISTRIBUTOR ID AND CUTS OUT THE NECESSARY INFORMATION FOR VARIABLE MATCHING
distro_alt=$(hostnamectl | awk 'NR==6 {print $3}')
       if [ "$distro" == "$debian" ] || [ "$distro" == "$ubuntu" ]; then
               resolvectl domain <interface_name> domain names #TESTED FOR MINT AND UBUNTU WHEN USING RESOLVE SERVICE
	       install_strgswn_deb
       elif [ "$distro_alt" == "$suse" ]; then
               install_strgswn_suse
       elif [ "$distro" == "$mint" ]; then
           resolvectl domain <interface_name> domain names #TESTED FOR MINT AND UBUNTU WHEN USING RESOLVE SERVICE
           install_strgswn_deb
       else
               echo "Operating not supported yet. Please contact your administrator in regards to VPN"
       fi
}

install_strgswn_deb(){ #INSTALLS STRONGSWAN
                if [ "$(dpkg -l | grep -Ew 'strongswan|libcharon-extra-plugins|libcharon-extauth-plugins|libstrongswan-extra-plugins' | wc -l)" -ge 5 ]; then
            file_configuration
                else
            apt-get update -y
            apt install -y strongswan libcharon-extra-plugins libcharon-extauth-plugins libstrongswan-extra-plugins
                    install_strgswn_deb
                fi
}

install_strgswn_suse(){ #REQUIRES FURTHER TESTING
        if [ "$(dpkg -l | grep -Ew 'strongswan|libcharon-extra-plugins|libcharon-extauth-plugins|libstrongswan-extra-plugins' | wc -l)" -ge 5 ]; then
                        file_configuration
                else
			echo "blob"
                fi
}

file_configuration(){ #CONFIGURES THE VARIOUS FILES NEEDED FOR STRONGSWAN
sed -i '/net.ipv4.ip_forward=1/s/^#//; /net.ipv6.conf.all.forwarding=1/s/^#//; /net.ipv4.conf.all.accept_redirects[[:space:]]=[[:space:]]0/s/^#//; /net.ipv4.conf.all.send_redirects[[:space:]]=[[:space:]]0/s/^#//' /etc/sysctl.conf
sh -c 'echo include /etc/ipsec_files/*.conf >> /etc/ipsec.conf'
mkdir /etc/ipsec_files
cp *.conf /etc/ipsec_files
sed -i sed "/xauth_identity=/s/$/$username/" /etc/ipsec_files/*.conf
cat ipsec.secrets >> /etc/ipsec.secrets
sed -i "s/preshared/$pw_secret/g; s/username/$username/g; s/password/$password/g" /etc/ipsec.secrets
service_reboot
}

service_reboot(){ #REBOOTS SERVICES AND READY SECRET KEYS
sysctl -p
systemctl restart strongswan #might not work if you're on MINT
ipsec rereadsecrets
ipsec update
ipsec reload
ipsec restart
}



#debug(){
#cat /etc/sysctl.conf
#cat /etc/ipsec.conf
#cat /etc/ipsec.secrets
#}

