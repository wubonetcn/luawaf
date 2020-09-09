# LuaWAF

一个用Lua写的WEB应用防火墙(WAF)。

新版本将会陆续更新。

如果你发现了绕过漏洞，请在`Issues`中提交详细细节。


[English version README](https://github.com/wubonetcn/luawaf/blob/master/README_EN.MD)

## 全新版本
一年来，我断断续续对此WAF进行了更新，目前已经完成了以下工作，有时间我会陆陆续续上传代码：
1. 访问控制功能：IP黑白名单控制、地域黑白名单控制（国家省市）、URI级别的CC防御
2. 检测正则升级，支持更多更新的攻击类型检测防护
3. 尝试更改为分布式版本
4. AI引擎测试，效果并不理想。
5. 新写了Go语言版本的中心控制节点、Vue版本的前端控制中心
6. SSL配置
7. 测试性的边缘函数（不成熟的）
8. 完善了扫描器、机器人识别规则
9. 新增了全自动封禁恶意IP功能

## How to use
>>>>>>> 8e785d7d61e86463700d284f05c3baf70f6eb6a5

## 新版本目录
```
/
    luawaf           -waf引擎(lua)
    webFrontend      -前端(vue)
    webBackend       -后端(Go)
```

## 新版概览
### 首页
![首页](https://s1.ax1x.com/2020/09/09/w3g8G6.png)
### WAF配置页面
![WAF配置页面](https://s1.ax1x.com/2020/09/09/w3g5iq.png)
### CC防护规则页面
![CC防护规则页面](https://s1.ax1x.com/2020/09/09/w32ZFI.png)
### 访问控制页面
![访问控制页面](https://s1.ax1x.com/2020/09/09/w32YYq.png)

## 旧版本
以下内容均为旧版本内容，新版本将会陆续更新。

## 如何使用

### 安装 OpenResty

在不同的操作系统上安装OpenResty有不同的方法。这里我只拿CentOS7做演示。

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

### 克隆这个项目

这个项目能在任何安装了OpenResty的操作系统上运行，包括但不限于CentOS。

```shell
git clone https://github.com/wubonetcn/luawaf.git
cp luawaf /usr/local/openresty/nginx/conf/
```

### 编辑 `/usr/local/openresty/nginx/conf/nginx.conf`

```shell
vim /usr/local/openresty/nginx/conf/nginx.conf
```

/usr/local/openresty/nginx/conf/nginx.conf

```shell
user  nobody;
worker_processes  1;

error_log  logs/error.log;
#error_log  logs/error.log  notice;
#error_log  logs/error.log  info;

#pid        logs/nginx.pid;


events {
    worker_connections  1024;
}


http {
    include       mime.types;
    default_type  application/octet-stream;

    #log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
    #                  '$status $body_bytes_sent "$http_referer" '
    #                  '"$http_user_agent" "$http_x_forwarded_for"';

    #access_log  logs/access.log  main;

    sendfile        on;
    #tcp_nopush     on;

    #keepalive_timeout  0;
    keepalive_timeout  65;

    #gzip  on;

    server {
        listen       80;
        server_name  localhost;

        #charset koi8-r;

        #access_log  logs/host.access.log  main;

        location / {
            root   html;
            index  index.html index.htm;
        }

        #error_page  404              /404.html;

        # redirect server error pages to the static page /50x.html
        #
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
        }

        # proxy the PHP scripts to Apache listening on 127.0.0.1:80
        #
        #location ~ \.php$ {
        #    proxy_pass   http://127.0.0.1;
        #}

        # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
        #
        #location ~ \.php$ {
        #    root           html;
        #    fastcgi_pass   127.0.0.1:9000;
        #    fastcgi_index  index.php;
        #    fastcgi_param  SCRIPT_FILENAME  /scripts$fastcgi_script_name;
        #    include        fastcgi_params;
        #}

        # deny access to .htaccess files, if Apache's document root
        # concurs with nginx's one
        #
        #location ~ /\.ht {
        #    deny  all;
        #}
    }


    # another virtual host using mix of IP-, name-, and port-based configuration
    #
    #server {
    #    listen       8000;
    #    listen       somename:8080;
    #    server_name  somename  alias  another.alias;

    #    location / {
    #        root   html;
    #        index  index.html index.htm;
    #    }
    #}


    # HTTPS server
    #
    #server {
    #    listen       443 ssl;
    #    server_name  localhost;

    #    ssl_certificate      cert.pem;
    #    ssl_certificate_key  cert.key;

    #    ssl_session_cache    shared:SSL:1m;
    #    ssl_session_timeout  5m;

    #    ssl_ciphers  HIGH:!aNULL:!MD5;
    #    ssl_prefer_server_ciphers  on;

    #    location / {
    #        root   html;
    #        index  index.html index.htm;
    #    }
    #}
    lua_package_path "/usr/local/openresty/nginx/conf/luawaf/?.lua;/usr/local/openresty/lualib/?.lua;;";
    lua_shared_dict limit 10m;
    init_by_lua_file  /usr/local/openresty/nginx/conf/luawaf/init.lua; 
    access_by_lua_file /usr/local/openresty/nginx/conf/luawaf/main.lua;

}
```

### 运行 Nginx

```shell
nginx
```

享受它!

## 详细设计文档

请阅读如下文章。

* [《基于OpenResty的WAF构建笔记》](https://www.wubo.net.cn/security/dev_waf.html)
* [《使用wrk2压力测试WAF》](https://www.wubo.net.cn/security/wrk2_test_waf.html)
* [《Web应用防火墙执行流程（执行模块）》](https://www.wubo.net.cn/security/waf_flow_chart.html)
* [《OpenResty学习笔记》](https://www.wubo.net.cn/security/learn_openresty.html)
* [《SQL注入学习笔记》](https://www.wubo.net.cn/security/learn_sql_injection.html)
* [《XSS(跨站脚本攻击)学习笔记》](https://www.wubo.net.cn/security/learn_xss.html)
* [《Lua学习笔记》](https://www.wubo.net.cn/security/learn_lua.html)
* [《扫描器扫描、路径穿越攻击、CC攻击特征学习笔记》](https://www.wubo.net.cn/security/learn_other_attacks.html)

这个项目借鉴了 [loveshell/ngx_lua_waf](https://github.com/loveshell/ngx_lua_waf),感谢 [神奇的魔法师](https://weibo.com/opscode).
这个项目修复了原项目存在的一些绕过漏洞。

## 更新日志

* 2019.07.09 增加了LUAJIT_LIB与LUAJIT_INC配置项以支持LUAJIT
* 2019.06.12 开源此项目
