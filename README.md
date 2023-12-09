# 基于SprigBoot的简单图书管理系统！

## 测试网站

[http://lib.123417.xyz](http://lib.123417.xyz)

账号：admin

密码：admin

## 项目运行

### 前期准备

> github代理地址

https://mirror.ghproxy.com/

1. 安装docker

```shell
apt install docker.io
```

2. 安装docker-compose

```shell
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

3. 下载文件

```shell
git clone https://github.com/wuyq54517/librarySystem.git
```

### 需要修改的文件

1. application.yml

```yml
spring:
  datasource:
    username: root
    password: YourMysqlPassword # mysql密码
    url: jdbc:mysql://xxx.xxx.xxx.xxx:3306/big_event #换成自己的ip和端口
    driver-class-name: com.mysql.cj.jdbc.Driver
    type: com.alibaba.druid.pool.DruidDataSource
  data:
    redis:
      host: xxx.xxx.xxx.xxx #换成自己的ip
      port: 6379
      password: YourRedisPassword #redis 密码
      

oss: 
# 阿里云oos配置信息
  endpoint: "https://oss-cn-beijing.aliyuncs.com"
  access-key-id: "your-access-key-id"
  access-key-secret: "your-access-key-secret"
  bucket-name: "your-bucket-name"
  
mybatis:
  configuration:
    map-underscore-to-camel-case: true 
    log-impl: org.apache.ibatis.logging.stdout.StdOutImpl

```

2. redis/redis.conf

> 填写你在application.yml配置的对应redis.password

```
requirepass YourRedisPassword
```

3. docker-compose.yml

```yml
version: "3"
services:
  nginx:
    image: nginx:latest
    ports:
      - 81:81 # 暴露对应端口
    volumes:
      - ./nginx/html:/usr/share/nginx/html
      - ./nginx/nginx.conf:/etc/nginx/nginx.conf
    privileged: true

  mysql:
    restart: always
    image: mysql:8.2.0
    ports:
      - 3306:3306
    environment:
      - MYSQL_ROOT_PASSWORD=YourMysqlPassword # mysql root 密码
      - MYSQL_DATABASE=big_event
      - MYSQL_USER=big_event
      - MYSQL_PASSWORD=YourMysqlPassword
    volumes:
      - ./sql/init.sql:/docker-entrypoint-initdb.d/init.sql
      - ./data:/var/lib/mysql
      
  redis:
    image: redis:latest
    ports:
      - 6379:6379
    volumes:
      - ./redis/redis.conf:/etc/redis/redis.conf
    command: ["redis-server", "/etc/redis/redis.conf"]

  vuelibiary:
    image: vueblog:latest
    build: .
    ports:
      - 8080:8080
    depends_on:
      - mysql
      - redis
```

4. nginx/nginx.conf

```shell
#user  root;
worker_processes  1;
events {
  worker_connections  1024;
}
http {
  include       mime.types;
  default_type  application/octet-stream;
  sendfile        on;
  keepalive_timeout  65;
  server {
      listen       81; # 在docker-compose.yml对应的nginx端口
      server_name  xxx.xxx.xxx.xxx; # 你的服务器ip或者对应域名
      location / {
          root   /usr/share/nginx/html;
          try_files $uri $uri/ /index.html;
          index  index.html index.htm;
      }
      
      error_page   500 502 503 504  /50x.html;
      location = /50x.html {
          root   html;
      }

    location /api {
        proxy_pass http://20.222.207.71:8080;  # 后台服务对应的源
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        rewrite ^/api(/.*)$ $1 break;  # 重写路径，去掉 '/api'
    }
     
  }


}
```

### 运行

```shell
docker-compose up -d 
```

