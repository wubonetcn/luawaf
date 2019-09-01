# LuaWAF

一个用Lua写的WEB应用防火墙(WAF)。
这个项目借鉴了 [loveshell/ngx_lua_waf](https://github.com/loveshell/ngx_lua_waf)。
这个项目修复了原项目存在的一些绕过漏洞。

诚然，防火墙总是存在漏洞，但我会坚持发现并修复这些漏洞。

如果你发现了绕过漏洞，请在`Issues`中提交详细细节。

项目官网： [luawaf.com](https://luawaf.com)

项目邮箱： [admin@luawaf.com](mailto:admin@luawaf.com)

LuaWAF交流QQ群: 618740528

当前版本会保存所有POST内容到日志文件，过几天再更新日志保存开关。

[English version README](https://github.com/wubonetcn/luawaf/blob/master/README.MD)

## 特性
* 敏感信息保护。隐藏服务器信息，server字段。隐藏服务器程序信息，x-powered-by字段。
* IP黑白名单
* URI黑白名单
* XSS防护
* SQL注入防护
* 路径穿越防护
* 上传文件内容检查
* base64编码内容检查

## 开发计划
* 支持API防护（列入日程）
* 可配置深度POST检测（已完成，待优化）


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

## 更新日志

* 2019.09.01 重写了POST检查，支持检查文件内容，支持图片马的检查，支持了base64编码的检查。修复了POST不能正常进行日志记录的bug。
* 2019.08.04 修复了不能正常记录日志的问题。新增了记录恶意cookies的功能。新增了白名单IP和黑名单IP的打开开关。为此项目搭建了简易官网`luawaf.com`。
* 2019.07.09 增加了LUAJIT_LIB与LUAJIT_INC配置项以支持LUAJIT。
* 2019.06.12 开源此项目。
