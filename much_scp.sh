#!/bin/bash
# for  scp file to the ip.txt and tar
# write by babysafer  in fq 20171123

##########config eare##############
USER=obdsapp
USER_PASSWD=
TARGET_PATH=/tmp/hb_client.tar.gz
########## end ####################

#for get the path of ip.txt
current_dir="`dirname $0`"
cd ${current_dir} && current_dir=`pwd` && cd - &>/dev/null
target="${current_dir}/ip.txt"


if [ $# -eq 2 ]
then
	clusterHostname=( `awk '{print $2}' ${target}` )
	USER=`whoami`
	for hostname in ${clusterHostname[*]}
		do
		    echo -e "\033[31m ***********$USER@@@$hostname**********  \033[0m"
expect <<EOF
	        spawn	scp -o StrictHostKeyChecking=no -r  $1 $USER@$hostname:$2
			expect {
				"yes/no" {send "yes\r", exp_continue}
				"*assw*" {send "${USER_PASSWD}\r"}
					}
	expect eof
	        spawn	ssh $USER@$hostname "tar -zxvf $TARGET_PATH -C ~"
			expect {
				"yes/no" {send "yes\r", exp_continue}
				"*assw*" {send "${USER_PASSWD}\r"}
					}
	expect eof
EOF
		done
else
	echo -e  "\033[31m please input filename and purposepath  \033[0m"
fi
