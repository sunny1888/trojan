#!/bin/bash


green='\e[0;32m' 
blue='\e[0;36m' 
end='\e[0m' 

# ssl一键安装脚本
easy_ssl() {
	yum update -y
	yum install -y curl
	yum install -y socat
	echo -e "${blue} acme.sh strat installing!...${end}"
	# acme.sh的脚本21年后更新为：
	curl https://get.acme.sh | sh -s email=my@example.com
	echo -e "${blue} acme.sh installed success! ${end}"
	echo -e "${blue} acme.sh path:: ~/.acme.sh/--this is hidden folder,If you want to see it,pls command 'ls -a'.${end}"

	systemctl stop nginx
	read -p " 请输入域名(xxx.com): " ansdomain
	if [ ${#ansdomain} > 1 ]; then
		read -p " 是否已经安装 Apache or Nginx?(y/n): " Aans
		# 如果你用的 apache/nginx服务器, acme.sh 还可以智能的从 apache/nginx的配置中自动完成验证（生成验证文件并自动删除）, 你不需要指定网站根目录
		if [ ${#Aans} == 'y' ||  ${#Aans} == 'Y']; then
			read -e -p " 1.Apache \n 2.Nginx " Bans
			if [ ${#Bans} == 1]; then
				acme.sh --issue -d ${ansdomain} --apache
			elif [ ${#Bans} == 2]; then
				acme.sh --issue -d ${ansdomain} --nginx
			else
				echo -e "${blue} 输入有误! ${end}"
				echo -e "${blue} 脚本被中断! ${end}"
			fi
		elif [ ${#Aans} == 'n' ||  ${#Aans} == 'N']; then
		# 如果没有装apache/nginx服务器, 需要指定网站根目录完成验证（生成验证文件并自动删除）
			read -p " 指定网站根目录(例如：/home/wwwroot/mydomain.com/)::" Cans
			~/.acme.sh/acme.sh --issue -d ${ansdomain} -d www.${ansdomain} --webroot ${Cans}
		else
			echo -e "${blue} 输入有误! ${end}"
			echo -e "${blue} 脚本被中断! ${end}"
		fi
		# 把证书 copy 到真正需要用它的地方
		# (注意, 默认生成的证书都放在安装目录下: ~/.acme.sh/, 请不要直接使用此目录下的文件)
		# Nginx example(例如):
		# acme.sh --install-cert -d example.com \
		# --key-file       /path/to/keyfile/in/nginx/key.pem  \
		# --fullchain-file /path/to/fullchain/nginx/cert.pem \
		# --reloadcmd     "service nginx force-reload"
		~/.acme.sh/acme.sh --installcert -d ${ansdomain} --key-file /root/private.key --fullchain-file /root/cert.crt
		echo -e "${green} 证书(private.key & cert.crt)成功生成到此:: /root/ ${end}"
		echo -e "${green} 记得把证书copy到真正需要用它的地方！ ${end}"
		echo -e "${green} 可参考非官方： https://www.ioiox.com/archives/87.html ${end}"
		echo -e "${green} 可参考官方：https://github.com/acmesh-official/acme.sh 的中文说明${end}"
		

	else
		echo -e "${blue} 域名为空! ${end}"
		echo -e "${blue} 脚本被中断! ${end}"
	fi
}

easy_ssl
