# 使用官方的 debian 镜像作为基础镜像
FROM openjdk:17
# 设置工作目录
WORKDIR /app
#RUN apt-get update && apt-get install openjdk-17-jdk -y
# 复制本地的 JAR 文件到容器中
COPY big-event-1.0-SNAPSHOT.jar /app/big-event-1.0-SNAPSHOT.jar
COPY application.yml /app/application.yml
# 暴露应用程序的端口（如果需要）
EXPOSE 8080
# 在容器启动时运行的命令
CMD ["java", "-jar", "big-event-1.0-SNAPSHOT.jar","--spring.config.location=file:/app/application.yml"]