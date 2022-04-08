if [ -n $1 ]; then
	echo "停止 $1"
	ps -ef |grep -i "cloudflared tunnel" | grep -i "$1" | grep -v grep | awk '{print $2}' | xargs kill -9 >/dev/null 2>&1
else 
	echo "停止所有隧道"
	ps -ef | grep -i "cloudflared tunnel" | grep -v grep | awk '{print $2}' | xargs kill -9 >/dev/null 2>&1
fi 
