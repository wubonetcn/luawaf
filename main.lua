--[[
遗留BUG：
1. [《openresty的unescape_uri函数处理百分号后面字符的小特性》](https://www.cnxct.com/openresty-unescape_uri-feature-to-decode-char-after-percent-sign/) 未解决 可以按照该篇文章中的方法重新编译OpenResty解决。
]]
setGlobalHeader()
if isWhiteIp() then
elseif isBlackIp() then
    ngx.exit(403)
elseif isCcAttack() then
    ngx.exit(503)
elseif isScanner() then
    ngx.exit(444)
elseif isWhiteUri() then
elseif isBlackUa() then
    log('UA', ngx.var.request_uri, '-', 'BlackUa')
    say_html()
elseif isBlackUri() then
    log('GET', ngx.var.request_uri, '-', 'BlackUri')
    say_html()
elseif isBlackGetArgs() then
    log('GET', ngx.var.request_uri, '-', 'BlackGetArgs')
    say_html()
elseif isBlackCookieArgs() then
    log('Cookie', ngx.var.request_uri, ngx.var.http_cookie, 'BlackCookieArgs')
    say_html()
else
    local post_status, post_data = isBlackPostArgs()
    if post_status then
        log('POST', ngx.var.request_uri, post_data, 'BlackPostArgs')
        say_html()
    else
        return
    end
end
