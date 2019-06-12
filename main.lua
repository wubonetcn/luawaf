--[[
遗留BUG：
1. [《openresty的unescape_uri函数处理百分号后面字符的小特性》](https://www.cnxct.com/openresty-unescape_uri-feature-to-decode-char-after-percent-sign/) 未解决 可以按照该篇文章中的方法重新编译OpenResty解决。
]]
if isWhiteIp() then
elseif isBlackIp() then
    ngx.exit(403)
elseif isCcAttack() then
    ngx.exit(503)
elseif isScanner() then
    ngx.exit(444)
elseif isWhiteUri() then
elseif isBlackUa() then
    log('UA', ngx.var.request_uri, "-", "当前UA在黑名单中")
    say_html()
elseif isBlackUri() then
    log('GET', ngx.var.request_uri, "-", "当前请求的URI在黑名单中")
    say_html()
elseif isBlackGetArgs() then
    log('GET', ngx.var.request_uri, "-", "当前GET请求的某一参数在黑名单中")
    say_html()
elseif isBlackCookie() then
    log('Cookie', ngx.var.request_uri, "-", "当前cookie中的某一参数在黑名单中")
    say_html()
elseif isBlackPostArgs() then
    log('POST', ngx.var.request_uri, data, "当前POST请求的某一参数在黑名单中")
    say_html()
else
    return
end
