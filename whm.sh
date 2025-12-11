#!/bin/bash

export LANG=en_US.UTF-8
export uuid=${UUID:-$(cat /proc/sys/kernel/random/uuid)}
export domain=${DOMAIN:-''}
export vl_port=${PORT:-$(shuf -i 10000-65535 -n 1)}

# 强制指定工作目录（Pterodactyl 标准路径）
BASE_DIR="/home/container"
WEBROOT="$BASE_DIR/domains/$domain/public_html"
mkdir -p "$WEBROOT"

# 杀掉可能存在的旧进程（可选，谨慎使用）
fips aux | grep '[d]omains' | awk '{print $2}' | xargs -r kill -9

# 下载文件
curl -s -o "$WEBROOT/app.js" "https://raw.githubusercontent.com/grh200002/sb-nodejs-yonggekkk222/vless-nodejs/main/app.js"
curl -s -o "$WEBROOT/package.json" "https://raw.githubusercontent.com/grh200002/sb-nodejs-yonggekkk222/vless-nodejs/main/package.json"

# 替换配置
sed -i "s/('UUID', '')/('UUID', '$uuid')/g" "$WEBROOT/app.js"
sed -i "s/('DOMAIN', '')/('DOMAIN', '$domain')/g" "$WEBROOT/app.js"
sed -i "s/('PORT', '')/('PORT', '$vl_port')/g" "$WEBROOT/app.js"

# 保存订阅链接
echo "https://$domain/$uuid" > "$BASE_DIR/domains/keepsub.txt"

# 输出信息
serv=$(hostname -s)
echo "---------------------------------------------"
echo "安装结束"
echo
echo "ctrl+选中下面网址，右击复制"
echo "https://$serv.webhostmost.com:2222/evo/user/plugins/nodejs_selector#/"
echo "请另外打开浏览器窗口，粘贴以上网址，可绕过限制进入Nodejs界面，设置相关参数即可"
echo "最后，打开支持保活的节点分享链接：https://$domain/$uuid"
echo "（已保存在 $BASE_DIR/domains/keepsub.txt）"
