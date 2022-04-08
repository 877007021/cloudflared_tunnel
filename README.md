# cloudflared 内网穿透脚本
## 脚本说明
```json
run.sh 启动脚本
status.sh 状态检查
stop.sh 停止隧道
```

## 使用
run.sh 默认寻找`baseDir`下的`config`中的所有配置文件
配置文件格式: 二级域名.yml。如:

> 主域名：test.top，二级域名: git.test.top
>
> 则配置文件名称就是: git.yaml

使用方式：

``` shell
sh run.sh    # 将config目录下的所有隧道启动，已经启动的会忽略
sh run.sh git http://127.0.0.1:80    # 自动在 config 目录下创建 git.yaml 并且启动
```

## 注意

在使用此脚本时请确保已经安装 cloudflared 服务
安装参考：[cloudflared](https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/installation/),下载对应的版本
以服务方式启动：

```shell
cloudflared install
```

登陆，获取授权

``` shell
cloudflared tunnel login
```


