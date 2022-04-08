domain="test.top"
baseDir="/opt/cloudflared"
start() {
	for name in $(ls "$baseDir/config") 
	do
	    serviceName=$(echo $name | awk -F '.' {'print $1'})
	    servicePid=$(ps -ef | grep -v grep | grep cloudflared | grep $serviceName | awk {'print $2'}) 

	    if [ -z "$servicePid" ]; then
	        echo "启动 $serviceName"
	        nohup cloudflared tunnel --no-autoupdate --loglevel=debug --config $baseDir/config/$name run $serviceName >> ./logs/$serviceName.log 2>&1 &
	    fi
	    if [ -n "$servicePid" ]; then
	        echo "服务 $serviceName 已启动, PID: $servicePid"
	    fi
	done
}

addTunnel() {
	secondaryDomain=$1
	host=$2
	if [ -n "$secondaryDomain" -a -n "$host" ]; then
		echo "添加隧道 $secondaryDomain"
		addInfo=$(cloudflared tunnel create $secondaryDomain)
		id=$(echo $addInfo | awk {'print $5'} | awk -F '/' {'print $4'} | awk -F '.' {'print $1'})
		cloudflared tunnel route dns $id $secondaryDomain
		touch $baseDir/config/$secondaryDomain.yml
		cat <<-EOF > $baseDir/config/$secondaryDomain.yml
			tunnel: $id
			credentials-file: /root/.cloudflared/$id.json

			ingress:
			  - hostname: $secondaryDomain.$domain
			    service: $host
			  - service: http_status:404
		EOF
	fi
}

addTunnel $1 $2
start