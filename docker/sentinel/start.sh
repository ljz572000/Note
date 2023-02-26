#!/bin/sh
app_file=sentinel-dashboard.jar
log_file=sentinel-dashboard.log
env=dev

wget -c https://ghproxy.com/https://github.com/alibaba/Sentinel/releases/download/1.8.5/sentinel-dashboard-1.8.5.jar -O sentinel-dashboard.jar

echo ${env}环境启动文件平台jar包:${app_name}
nohup java -Dserver.port=7070 -Dcsp.sentinel.dashboard.server=localhost:7070 -Dproject.name=sentinel-dashboard -jar sentinel-dashboard.jar > ${log_file} 2>&1 & tail -f ./${log_file}