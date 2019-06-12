--WAF日志开关
WafLog = "on"
--日志文件夹
LogPath = "/usr/local/openresty/nginx/logs/luawaf/"
RulePath = "/usr/local/openresty/nginx/conf/luawaf/rules/"
--配置白名单IP列表
WhiteIpList = { "127.0.0.1" }
--配置黑名单IP列表
BlackIpList = { "1.0.0.1" }
--是否开启CC攻击检查
CheckCC = "off"
--配置CC攻击频率阈值，次/秒
CCFrequency = "100/60"
--是否开启白名单URI检查
CheckWhiteUri = "on"
--是否开启黑名单URI检查
CheckBlackUri = "on"
--是否开启黑名单Cookie检查
CheckBlackCookie = "on"
--是否开启POST黑名单信息检查
CheckBlackPostArgs = "on"
--配置POST文件上传后缀黑名单
BlackFileExt = { "php", "jsp" }
--是否返回拦截页面
Return403Page = "on"
--配置403页面
html = [[
<html>
<head><meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1"><meta name="robots" content="none" /><title>403 Forbidden</title>
<style>
*{font-family:"Microsoft Yahei";margin:0;font-weight:lighter;text-decoration:none;text-align:center;line-height:2.2em;}
html,body{height:100%;}
h1{font-size:100px;line-height:1em;}
table{width:100%;height:100%;border:0;}
</style>
</head>
<body>
<table cellspacing="0" cellpadding="0">
<tr>
<td>
<table cellspacing="0" cellpadding="0"><tr><td>
<h1>403</h1>
<h3>请求被拦截</h3>
<p>你可能在网站管理员的黑名单里，或者你发起了不正常的请求。<br/>
<a href="/">联系管理员</a></p>
</td>
</tr>
</table>
</td>
</tr>
</table>
</body>
</html>  
]]
