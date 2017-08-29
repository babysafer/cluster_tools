#!/bin/bash
# for  scp file to the ip.txt
# write by babysafer  in fq 20170504

##########   用途 ################
# 主机间没有信任关系，但是用户名密码一样
# 可以ssh到ip.txt里面的主机上去执行一条命令

######config area######
ROOT_PASSWD=    #root passwd
USER=`whoami`
######config end#######


current_dir="`dirname $0`"
cd ${current_dir} && current_dir=`pwd` && cd - &>/dev/null
target="${current_dir}/ip.txt"

if [ $# -eq 1 ]
then
	clusterHostname=( `awk '{print $1}' ${target}` )
	for ip in ${clusterHostname[*]}
		do
		 echo -e "\033[31m *******$USER@$ip**********  \033[0m"
expect <<EOF
        spawn ssh -o StrictHostKeyChecking=no     $USER@$ip  "source /etc/profile;$1"
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
