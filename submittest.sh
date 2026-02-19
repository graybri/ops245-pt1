#!/usr/bin/env bash


# Test for sudo
user=$(whoami)
if [ $user != "root" ]
then
    echo "You must run this script with root privileges. Please use sudo" >&2
    exit 1
fi

# Variables
testlog=/var/log/ops245.log
testvarfile=/var/log/.testvars
semester="w26"
profacct="brian.gray"
profmail="brian.gray@senecapolytechnic.ca"
numdate="$(date +%s)"
source $testvarfile
submitfile="${senecaacct}-${section}-${numdate}.log"
matrixpath="/home/${profacct}/ops245/pt1/${semester}/${section}/"
suser=${SUDO_USER:-$USER}

# Adding .testvars contents
echo | tee -a $testlog
echo "TESTVARS" | tee -a $testlog
cat $testvarfile | tee -a $testlog
echo "SRAVTSET" | tee -a $testlog

# passwd 
echo | tee -a $testlog
echo "PASSWD" | tee -a $testlog
tail -5 /etc/passwd | tee -a $testlog
echo "DWSSAP" | tee -a $testlog

# group 
echo | tee -a $testlog
echo "GROUP" | tee -a $testlog
tail -5 /etc/group | tee -a $testlog
grep "^sudo" /etc/group | tee -a $testlog
echo "PUORG" | tee -a $testlog

# alias 
echo | tee -a $testlog
echo "ALIAS" | tee -a $testlog
grep "alias" ~ops245/.bash* /home/${suser}/.bash* | tee -a $testlog
grep "alias" ~ops245/.bash* /home/${senecaacct}/.bash* | tee -a $testlog
echo "SAILA" | tee -a $testlog

# vsftpd
echo | tee -a $testlog
echo "VSFTPD" | tee -a $testlog
systemctl status vsftpd | egrep "Loaded:|Active:" | tee -a $testlog
echo "DPTFSV" | tee -a $testlog

# Install micro, Remove cowsay
echo | tee -a $testlog
echo "PACKAGES" | tee -a $testlog
dpkg -l cowsay 2>&1 | tail -1 | tee -a $testlog
dpkg -l micro 2>&1 | tail -1 | tee -a $testlog
echo "SEGAKCAP" | tee -a $testlog

# Compile and Install lmarbles
echo | tee -a $testlog
echo "LMARBLES" | tee -a $testlog
echo "tarball found?" | tee -a $testlog
find /home -name 'lmarbles*.tar.gz' | tee -a $testlog
echo "tarball extracted?" | tee -a $testlog
find /home -type d -name 'lmarbles*' | tee -a $testlog
echo "./configure ran?" | tee -a $testlog
find /home -type f -name 'config.log' | tee -a $testlog
echo "make ran?" | tee -a $testlog
find /home -type f -name 'lmarbles' | tee -a $testlog
echo "make install ran?" | tee -a $testlog
which lmarbles | tee -a $testlog
echo "SELBRAML" | tee -a $testlog

# Save submit file
cp $testlog ~/backups/$submitfile

### Copy submit file to matrix

# Change interface to static
# ifdown enp1s0
# cp /root/backups/interfaces.static /etc/network/interfaces
# ifup enp1s0

# Reset iptables
# iptables -F
# iptables -P INPUT ACCEPT
# iptables -P OUTPUT ACCEPT

# scp to matrix
scp ~/backups/$submitfile $senecaacct@matrix.senecapolytechnic.ca:$matrixpath


