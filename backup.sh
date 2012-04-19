#!/bin/sh

# Use mysqldump --help get more detail.

#
# 定义变量，请根据具体情况修改
# 定义脚本目录
scriptsDir=`pwd`

# 定义用于备份数据库的用户名和密码
user=root
userPWD='221058_qm'

# 定义备份数据库名称
dbNames=(tech_blog show_blog)

# 定义备份目录
dataBackupDir=/var/www/backup

# 定义邮件正文文件
#eMailFile=$dataBackupDir/log/email.txt

# 定义邮件地址
#eMail=Huihua.Zhang@quidos.co.uk

# 定义备份日志文件
#logFile=$dataBackupDir/log/mysqlbackup.log

# DATE=`date -I`
DATE=`date -d "now" +%Y%m%d`

#echo `date -d "now" "+%Y-%m-%d %H:%M:%S"` > $eMailFile

for dbName in ${dbNames[*]}
do
    # 定义备份文件名
    dumpFile=$dataBackupDir/$dbName-$DATE.sql.gz

    # 使用mysqldump备份数据库，请根据具体情况设置参数
    mysqldump -u$user -p$userPWD $dbName -h127.0.0.1 | gzip > $dumpFile
done

#if [[ $? == 0 ]]; then
    #echo "DataBase Backup Success!" >> $eMailFile
#else
    #echo "DataBase Backup Fail!" >> $emailFile
#fi

# 写日志文件
#echo "================================" >> $logFile
#cat $eMailFile >> $logFile
#echo $dumpFile >> $logFile

# 发送邮件通知
#cat $eMailFile | mail -s "MySQL Backup" $eMail

# 定义推送到github的目录
git_dirs=(show_blog szyt-ic tech_blog backup)

for dir in ${git_dirs[*]}
do
    cd /var/www/$dir
    git add .
    git commit -m 'back up'
    git push
done
