#!/bin/bash
# for  scp file to the ip.txt
# write by babysafer  in fq 20170504

#for get the path of ip.txt

######config area######
ROOT_PASSWD=Dnt_2015    #root passwd
######config end#######
current_dir="`dirname $0`"
cd ${current_dir} && current_dir=`pwd` && cd - &>/dev/null
target="${current_dir}/ip.txt"

if [ $# -eq 1 ]
then
	clusterHostname=( `awk '{print $2}' ${target}` )
	USER=`whoami`
	for hostname in ${clusterHostname[*]}
		do
		 echo -e "\033[31m *******$USER@$hostname**********  \033[0m"
		 expect <<EOF
        spawn ssh -o StrictHostKeyChecking=no     $USER@$hostname  "source /etc/profile;$1"
		expect {
		"yes/no" {send "yes\r", exp_continue}
		"*assw*" {send "${ROOT_PASSWD}\r"}
		}
		expect eof
		EOF
		done
else
	echo -e  "\033[31m please input filename and purposepath  \033[0m"
fi
