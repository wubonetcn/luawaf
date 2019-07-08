# LuaWAF
A web application firewall(WAF) written in lua.
This project draws lessons from [loveshell/ngx_lua_waf](https://github.com/loveshell/ngx_lua_waf),Thank [神奇的魔法师](https://weibo.com/opscode).
This project fixes some bypass loopholes in the original project.
Admittedly, firewalls are always vulnerable, but I'm constantly fixing these vulnerabilities.

## How to use
### Install OpenResty
There are different ways to install OpenResty on different operating systems. Here I just take CentOS7 as an example.
```shell
yum update -y
yum install readline-devel pcre-devel openssl-devel perl gcc automake autoconf libtool make epel-release redis -y
cd Downloads
wgethttps://openresty.org/download/openresty-1.15.8.1.tar.gz
tar -xzvf openresty-1.15.8.1.tar.gz
cd openresty-1.15.8.1
./configure --with-luajit\
            --with-http_iconv_module
gmake
gmake install
echo export PATH=$PATH:/usr/local/openresty/nginx/sbin >> /etc/profile
source /etc/profile
```
### Clone this project
This project can run on any operating system with OpenResty installed, including but not limited to CentOS.
```shell
git clone https://github.com/wubonetcn/luawaf.git
cp luawaf /usr/local/openresty/nginx/conf/
```
### Edit `/usr/local/openresty/nginx/conf/nginx.conf`
```
vim /usr/local/openresty/nginx/conf/nginx.conf
```
/usr/local/openresty/nginx/conf/nginx.conf
```
#user  nobody;
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
### Run Nginx
```
nginx
```
Enjoy it!
## Detailed Design Document
Please read those post.
[《基于OpenResty的WAF构建笔记》](https://www.wubo.net.cn/security/dev_waf.html)
[《使用wrk2压力测试WAF》](https://www.wubo.net.cn/security/wrk2_test_waf.html)
[《Web应用防火墙执行流程（执行模块）》](https://www.wubo.net.cn/security/waf_flow_chart.html)
[《OpenResty学习笔记》](https://www.wubo.net.cn/security/learn_openresty.html)
[《SQL注入学习笔记》](https://www.wubo.net.cn/security/learn_sql_injection.html)
[《XSS(跨站脚本攻击)学习笔记》](https://www.wubo.net.cn/security/learn_xss.html)
[《Lua学习笔记》](https://www.wubo.net.cn/security/learn_lua.html)
[《扫描器扫描、路径穿越攻击、CC攻击特征学习笔记》](https://www.wubo.net.cn/security/learn_other_attacks.html)
