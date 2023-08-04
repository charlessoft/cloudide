#!/bin/bash
source ./config.sh

if [ "$#" -lt 1 ]; then
    echo "sh create_new_site.sh xxx"
    exit 1
fi

ACCOUNT=$1




echo "==========config web site config=========="
export SITE_NAME=${ACCOUNT}.${DOMAIN}
echo $SITE_NAME
mkdir -p /usr/local/nginx/conf/vhost/
mkdir -p /www/wwwlogs
mkdir -p /www/wwwroot/${SITE_NAME}


cat << EOF >/usr/local/nginx/conf/vhost/${SITE_NAME}.conf
server
{
    listen 80;
    server_name ${SITE_NAME};
    index index.php index.html index.htm default.php default.htm default.html;
    root /www/wwwroot/${SITE_NAME};

    #SSL-START SSL相关配置，请勿删除或修改下一行带注释的404规则
    #error_page 404/404.html;
    #SSL-END

    #ERROR-PAGE-START  错误页配置，可以注释、删除或修改
    #error_page 404 /404.html;
    #error_page 502 /502.html;
    #ERROR-PAGE-END

    #PHP-INFO-START  PHP引用配置，可以注释或修改
    #清理缓存规则

    #location ~ /purge(/.*) {
    #    proxy_cache_purge cache_one \$host\$1\$is_args\$args;
    #    #access_log  /www/wwwlogs/${SITE_NAME}_purge_cache.log;
    #}
      #引用反向代理规则，注释后配置的反向代理将无效
      include /www/server/panel/vhost/nginx/proxy/${SITE_NAME}/*.conf;

    #include enable-php-00.conf;
    #PHP-INFO-END

    #REWRITE-START URL重写规则引用,修改后将导致面板设置的伪静态规则失效
    #include /www/server/panel/vhost/rewrite/${SITE_NAME}.conf;
    #REWRITE-END

    #禁止访问的文件或目录
    location ~ ^/(\.user.ini|\.htaccess|\.git|\.env|\.svn|\.project|LICENSE|README.md)
    {
        return 404;
    }

    #一键申请SSL证书验证目录相关设置
    location ~ \.well-known{
        allow all;
    }

    #禁止在证书验证目录放入敏感文件
    if ( \$uri ~ "^/\.well-known/.*\.(php|jsp|py|js|css|lua|ts|go|zip|tar\.gz|rar|7z|sql|bak)$" ) {
        return 403;
    }

    location ~ .*\.(gif|jpg|jpeg|png|bmp|swf)$
    {
        expires      30d;
        error_log /dev/null;
        access_log /dev/null;
    }

    location ~ .*\.(js|css)?$
    {
        expires      12h;
        error_log /dev/null;
        access_log /dev/null;
    }
    access_log  /www/wwwlogs/${SITE_NAME}.log;
    error_log  /www/wwwlogs/${SITE_NAME}.error.log;
}
EOF


cat << EOF >/www/wwwroot/${SITE_NAME}/index.html

<html>
<body>
hello ${SITE_NAME}
</body>
</html>

EOF

# ====================================


echo "create proxy"
PROXY_NAME=default
DEFAULT_PORT=3000
# 创建反向代理
mkdir -p /www/server/panel/vhost/nginx/proxy/${SITE_NAME}
echo "create proxy ${CONTAINER_IP} ${DEFAULT_PORT} ${PROXY_NAME}"
sh create_proxy.sh ${CONTAINER_IP} ${DEFAULT_PORT} ${PROXY_NAME}

systemctl restart nginx


sh run_demo.sh
