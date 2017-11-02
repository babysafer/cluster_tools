#!/bin/bash
# for  scp file to the ip.txt
# write by babysafer  in fq 20170504

##########      用途     ########################
# 主机间有信任关系后，分发文件到集群所有主机的指定目录中


######config area######
USER=`whoami`
######config end#######


#for get the path of ip.txt
current_dir="`dirname $0`"
cd ${current_dir} && current_dir=`pwd` && cd - &>/dev/null
target="${current_dir}/ip.txt"


if [ $# -eq 2 ]
then
	clusterHostname=( `awk '{print $2}' ${target}` )
	for hostname in ${clusterHostname[*]}
		do
		    echo -e "\033[31m ***********$USER@@@$hostname**********  \033[0m"
			scp -r -o StrictHostKeyChecking=no $1 $USER@$hostname:$2
		done
else
	echo -e  "\033[31m please input filename and purposepath  \033[0m"
fi
