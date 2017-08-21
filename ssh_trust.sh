#!/bin/bash
# for  scp file to the ip.txt
# write by babysafer  in fq 20170809

##########config eare##############
USER_NAME=
USER_PASSWD=    
########## end ####################

#for get the path of ip.txt
current_dir="`dirname $0`"
cd ${current_dir} && current_dir=`pwd` && cd - &>/dev/null
target="${current_dir}/ip.txt"

#生成公钥，写入authroized_keys
if [ ! -f "~/.ssh/id_rsa" -o ! -f "~/.ssh/id_rsa.pub" ]; then
	        rm -rf ~/.ssh &> /dev/null
expect <<EOF
		    set timout 30
		    spawn ssh-keygen -t rsa
		    expect "Generating public*"
		    send "\r"
		    expect "Enter file"
		    send "\r"
		    expect *passphrase*
		    send "\r"
		    expect "*again*"
		    send "\r"
		    expect eof
EOF
fi
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys

#分发整个.ssh 目录
clusterHostname=( `awk '{print $2}' ${target}` )
for hostname in ${clusterHostname[*]}
	do
	    echo -e "\033[31m ***********${USER_NAME}@@@$hostname**********  \033[0m"
		spawn scp -r  ~/.ssh  ${USER_NAME}@$hostname:~
			expect {
				"yes/no" {send "yes\r", exp_continue}
				"*assw*" {send "${USER_PASSWD}\r"}
					}
			expect eof
		EOF
	done

