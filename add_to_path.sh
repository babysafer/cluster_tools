#!/bin/bash
# for  scp file to the ip.txt and tar
# write by babysafer  in fq 20171123

##########config eare##############
USER=obdsapp
USER_PASSWD=
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
	set timeout 60
	        spawn	ssh $USER@$hostname "echo '# for hbase' >> ~/.bash_profile"
			expect {
				"yes/no" {send "yes\r", exp_continue}
				"*assw*" {send "${USER_PASSWD}\r"}
					}
	expect eof
	        spawn	ssh $USER@$hostname "echo 'export HBASE_HOME=/obdsapp/hbase' >> ~/.bash_profile"
			expect {
				"yes/no" {send "yes\r", exp_continue}
				"*assw*" {send "${USER_PASSWD}\r"}
					}
	expect eof
	        spawn	ssh $USER@$hostname "echo 'export PATH=\\\$PATH:\\\$HBASE_HOME/bin' >> ~/.bash_profile"
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
