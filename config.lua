--WAF日志开关
WafLog = 'on'
--日志文件夹
LogPath = '/usr/local/openresty/nginx/logs/luawaf'
RulePath = '/usr/local/openresty/nginx/conf/luawaf/rules'
--是否开启白名单IP检查
CheckWhiteIp = 'off'
--配置白名单IP列表
WhiteIpList = {'127.0.0.1'}
--是否开启黑名单IP检查
CheckBlackIp = 'on'
--配置黑名单IP列表
BlackIpList = {'1.0.0.1'}
--是否开启CC攻击检查
CheckCC = 'off'
--配置CC攻击频率阈值，次/秒
CCFrequency = '100/60'
--是否开启白名单URI检查
CheckWhiteUri = 'on'
--是否开启黑名单URI检查
CheckBlackUri = 'on'
--是否开启黑名单Cookie检查
CheckBlackCookie = 'on'
--是否开启POST黑名单信息检查
CheckBlackPostArgs = 'on'
--配置POST文件上传后缀黑名单
BlackFileExt = {'php', 'jsp'}
--是否返回拦截页面
Return403Page = 'on'
--配置403页面
html = [[
{
"status":"Banned",
"message":"Protected by LuaWAF.com"
} 
]]
