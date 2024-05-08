#!/bin/bash

main() {
echo "Please type in rhel subscription portal username:"
read rhel_name
echo "Please type rhel subscription portal password:"
read -s rhel_pw
updating
install_packages
set_install
start_convert
send_mail
}

updating() {
echo "System maintenance in progress" > /run/nologin
systemctl stop autofs
systemctl disable autofs
}

install_packages() {
# IN CASE OF PROXY
#export https_proxy=<proxy_ip>
#export http_proxy=<proxy_ip>
curl -o /etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release https://www.redhat.com/security/data/fd431d51.txt -f
curl -o /etc/yum.repos.d/convert2rhel.repo https://ftp.redhat.com/redhat/convert2rhel/7/convert2rhel.repo -f
yum -y install convert2rhel
yum -y install subscription-manager.x86_64
}

set_install() {
sed -i "s/^# username/username/" /etc/convert2rhel.ini
sed -i "s/^# password/password/" /etc/convert2rhel.ini
sed -i "s/<insert_username>/${rhel_name}/" /etc/convert2rhel.ini
sed -i "s/<insert_password>/${rhel_pw}/" /etc/convert2rhel.ini
cat /etc/convert2rhel.ini | grep -e username -e password
export CONVERT2RHEL_DISABLE_TELEMETRY=1
# IN CASE OF PROXY
#sed -i "/proxy_hostname =/c\proxy_hostname = <proxy_ip>" /etc/rhsm/rhsm.conf
#sed -i "/proxy_port =/c\proxy_port = <proxy_port>" /etc/rhsm/rhsm.conf
#cat /etc/rhsm/rhsm.conf | grep proxy_
}

start_convert() {
convert2rhel analyze --debug -y
}

send_mail() {
mailx -s "convert2rhel log of machine $(hostname)" <type_user_here> </var/log/convert2rhel/convert2rhel.log
}

main
