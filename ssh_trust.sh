#!/bin/bash
# for scp file to the ip.txt
# write by babysafer  in fq 20170809
# this scripts for ssh login with No password required。


####### 需要传入的参数说明 ##############
#需传入两个个参数，
# $1 用户的家目录
# $2 用户的密码

######## 测试可以正常运行环境信息 #########
# 防火墙关闭，selinux关闭
# 主机用户名，密码相同，home目录一致

######## 需要配置的信息 #################
# 配置和脚本同级目录下的ip.txt信息


USER_NAME=`whoami`
USER_PASSWD=$2


#for get the path of ip.txt
current_dir="`dirname $0`"
cd ${current_dir} && current_dir=`pwd` && cd - &>/dev/null
target="${current_dir}/ip.txt"

# made public key and writing in authroized_keys
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

# scp the dirctory of .ssh to others host in ip.txt
clusterHostname=( `awk '{print $2}' ${target}` )
for hostname in ${clusterHostname[*]}
do
        echo -e "\033[31m ***********${USER_NAME}@@@$hostname**********  \033[0m"
expect <<EOF
        set timeout 30
        spawn scp  -o StrictHostKeyChecking=no  -r  $1/.ssh/  ${USER_NAME}@$hostname:~
        expect {
                "yes/no" {send "yes\r", exp_continue}
                "*assw*" {send "${USER_PASSWD}\r"}
                }
        expect eof
EOF
done
