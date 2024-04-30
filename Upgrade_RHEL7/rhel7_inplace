#!/bin/bash

updating() {
## IN CASE OF USING NFS UNCOMMENT  
#systemctl stop autofs
#systemctl disable autofs
yum clean all
yum update -y
}

install_packages() {
## IN CASE OF PROXY UNCOMMENT
#export https_proxy=https://**IP GOES HERE**/
curl -o /etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release https://www.redhat.com/security/data/fd431d51.txt -y
curl -o /etc/yum.repos.d/convert2rhel.repo https://ftp.redhat.com/redhat/convert2rhel/7/convert2rhel.repo -y
yum -y install convert2rhel
yum -y install subscription-manager.x86_64
}

set_install() {
sed -i "s/<insert_username>/${rhel_name}/" convert2rhel.ini
sed -i "s/<insert_password>/${rhel_pw}/" convert2rhel.ini
cat /etc/convert2rhel.ini | grep -e username -e password
export CONVERT2RHEL_DISABLE_TELEMETRY=1
## IN CASE OF PROXY UNCOMMENT
#sed -i "/proxy_hostname =/c\proxy_hostname = **IP GOES HERE**" /etc/rhsm/rhsm.conf
#sed -i "/proxy_port =/c\proxy_port = **PORT GOES HERE**" /etc/rhsm/rhsm.conf
cat /etc/rhsm/rhsm.conf | grep proxy_
}

start_convert() {
convert2rhel analyze --debug
}

main() {
echo "Please type rhel username: "
read -p rhel_name
echo "Please type rhel password: "
read -s rhel_pw
updating
install_packages
set_install
start_convert
}

main
