#!/bin/sh
# 杀死文件平台进程
app_file=sentinel-dashboard.jar
log_file=sentinel-dashboard.log
echo 杀死文件平台进程jar包:${app_file}
cp ${app_file} ./backup/$(date "+%Y-%m-%d_%H:%M:%S")${app_file}
mv ${log_file} ./backup/$(date "+%Y-%m-%d_%H:%M:%S")${log_file}

PID=`ps -ef | grep ${app_file} | grep -v grep | awk '{print $2}'`
if [ -z "$PID" ]
then
    echo sentinel dashboard Application is already stopped
else
    echo kill $PID
    kill -9 $PID
fi