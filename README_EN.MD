# LuaWAF

A web application firewall(WAF) written in lua.
This project fixes some bypass loopholes in the original project.

New versions will be updated.

If you find a bug bypassing, please submit details in `Issues'.

[中文版README](https://github.com/wubonetcn/luawaf/blob/master/README.MD)

## New version
Over the past year, I have updated this WAF intermittently. At present, I have completed the following work. When I have time, I will continue to upload the code:
1. Access control function: IP black and white list control, regional black and white list control (national and provincial), CC defense at URI level
2. Detect regular upgrade, support more updated attack type detection protection
3. Try to change to distributed version
4. AI engine test, the effect is not ideal.
5. The central control node of go language version and the front-end control center of Vue version are newly written
6. SSL configuration
7. Testability edge function (immature)
8. Improve the recognition rules of scanner and robot
9. Added the function of automatic blocking malicious IP
## Overview of the new edition
### Home page
![首页](https://s1.ax1x.com/2020/09/09/w3g8G6.png)
### WAF configuration page
![WAF配置页面](https://s1.ax1x.com/2020/09/09/w3g5iq.png)
### CC protection rules page
![CC防护规则页面](https://s1.ax1x.com/2020/09/09/w32ZFI.png)
### Access control page
![访问控制页面](https://s1.ax1x.com/2020/09/09/w32YYq.png)

## New version directory
```
/
    luawaf           -waf engine(lua)
    webFrontend      -front end(vue)
    webBackend       -backend(Go)
```

## Old version
The following content is the content of the old version, and the new version will be updated.

## How to use

### Install OpenResty

There are different ways to install OpenResty on different operating systems. Here I just take CentOS7 as an example.

```shell
yum update -y
yum install readline-devel pcre-devel openssl-devel perl gcc automake autoconf libtool make epel-release redis -y
cd Downloads
wget https://openresty.org/download/openresty-1.15.8.1.tar.gz
tar -xzvf openresty-1.15.8.1.tar.gz
cd openresty-1.15.8.1
./configure --with-luajit\
            --with-http_iconv_module
gmake
gmake install
echo export PATH=$PATH:/usr/local/openresty/nginx/sbin >> /etc/profile
echo export LUAJIT_LIB=/usr/local/openresty/luajit/lib >> /etc/profile
echo export LUAJIT_INC=/usr/local/openresty/luajit/include/luajit-2.1 >> /etc/profile
source /etc/profile

mkdir /usr/local/openresty/nginx/logs/luawaf
chown nobody /usr/local/openresty/nginx/logs/luawaf
```

### Clone this project

This project can run on any operating system with OpenResty installed, including but not limited to CentOS.

```shell
git clone https://github.com/wubonetcn/luawaf.git
cp luawaf /usr/local/openresty/nginx/conf/
```

### Edit `/usr/local/openresty/nginx/conf/nginx.conf`

```shell
vim /usr/local/openresty/nginx/conf/nginx.conf
```

/usr/local/openresty/nginx/conf/nginx.conf

```shell
user  nobody;
worker_processes  1;

error_log  logs/error.log;

events {
    worker_connections  1024;
}


http {
    include       mime.types;
    default_type  application/octet-stream;

    sendfile        on;
    keepalive_timeout  65;

    server {
        listen       80;
        server_name  localhost;

        location / {
            root   html;
            index  index.html index.htm;
        }

        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
        }
    }
    lua_package_path "/usr/local/openresty/nginx/conf/luawaf/?.lua;/usr/local/openresty/lualib/?.lua;;";
    lua_shared_dict limit 10m;
    init_by_lua_file  /usr/local/openresty/nginx/conf/luawaf/init.lua; 
    access_by_lua_file /usr/local/openresty/nginx/conf/luawaf/main.lua;

}
```

### Run Nginx

```shell
nginx
```

Enjoy it!

## Detailed Design Document

Please read those posts.

* [《基于OpenResty的WAF构建笔记》](https://www.wubo.net.cn/security/dev_waf.html)
* [《使用wrk2压力测试WAF》](https://www.wubo.net.cn/security/wrk2_test_waf.html)
* [《Web应用防火墙执行流程（执行模块）》](https://www.wubo.net.cn/security/waf_flow_chart.html)
* [《OpenResty学习笔记》](https://www.wubo.net.cn/security/learn_openresty.html)
* [《SQL注入学习笔记》](https://www.wubo.net.cn/security/learn_sql_injection.html)
* [《XSS(跨站脚本攻击)学习笔记》](https://www.wubo.net.cn/security/learn_xss.html)
* [《Lua学习笔记》](https://www.wubo.net.cn/security/learn_lua.html)
* [《扫描器扫描、路径穿越攻击、CC攻击特征学习笔记》](https://www.wubo.net.cn/security/learn_other_attacks.html)

This project draws lessons from [loveshell/ngx_lua_waf](https://github.com/loveshell/ngx_lua_waf),Thank [神奇的魔法师](https://weibo.com/opscode).

# Update logs

* 2019.07.09 Added LUAJIT_LIB and LUAJIT_INC configuration items to support LUAJIT
* 2019.06.12 Open Source Project
