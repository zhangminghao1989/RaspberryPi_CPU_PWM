#!/bin/sh


#设置运行状态文件
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

if [ -n "$1" ] ;then
CONF=$1
else
CONF=/home/pi/.cpu-fan.conf
fi
if [  -n "$2" ] ;then
LOG=$2
else
LOG=/var/log/cpu-fan/cpu-fan.log
fi

load=`cat /proc/loadavg | awk '{print $1}'`

#开机风扇全速运行
#默认的pwm值范围是0~1023
gpio mode 1 pwm
gpio pwm 1 1023


#初始化参数
fan=0

while true
  do
  #获取cpu温度
  tmp=`cat /sys/class/thermal/thermal_zone0/temp`

  #读取配置
  while read line; do
	name=`echo $line | awk -F '=' '{print $1}'`
	value=`echo $line | awk -F '=' '{print $2}'`
	case $name in
	"MODE")
	MODE=$value
	;;
	"set_temp_min")
	set_temp_min=$value
	;;
	"shutdown_temp")
	shutdown_temp=$value
	;;
	"set_temp_max")
	set_temp_max=$value
	;;
	*)
	;;
	esac
  done < $CONF
  
  #计算pwm值，从变量set_temp_min设置的温度开始开启风扇，最低转速50%
  pwm=$((($tmp-$set_temp_min)*512/($set_temp_max-$set_temp_min)+511))
  if [ $pwm -le 511 ] ;then
  pwm=511
  fi

  #设置pwm值上限
  if [ $pwm -gt 1023 ] ;then
  pwm=1023
  fi
    
  #第一次超过设置温度全速开启风扇，防止风扇不能启动
  if [ $tmp -gt $set_temp_min ] && [ $fan -eq 0 ] && [ $MODE -eq 2 ] ;then
  gpio pwm 1 1023
  fan=1
  echo "`date` temp=$tmp pwm=1023 MODE=$MODE CPU load=$load 第一次超过设置温度全速开启风扇" >> $LOG
  sleep 1
  fi
 
  #小于设置温度关闭风扇
if [ $fan -eq 0 ] ;then
  pwm=0
  fi
  if [ $tmp -le $shutdown_temp ] && [ $MODE -eq 2 ] ;then
  pwm=0
  fan=0
  gpio mode 1 pwm
  gpio pwm 1 $pwm
  sleep 5
  echo "`date` temp=$tmp pwm=$pwm MODE=$MODE CPU load=$load 小于设置温度关闭风扇 " >> $LOG
else

  #检查MODE，为0时关闭风扇
  if [ $MODE -eq 0 ] ;then
  pwm=0
  fan=0
  else
  
  #检查MODE，为1时持续开启风扇最高转速
  if [ $MODE -eq 1 ] ;then
  pwm=1023
  fan=1
  fi
  fi

  gpio mode 1 pwm
  gpio pwm 1 $pwm
    
  #输出日志

  echo "`date` temp=$tmp pwm=$pwm MODE=$MODE CPU load=$load 大于设置温度持续开启风扇" >> $LOG

  #每5秒钟检查一次温度
  sleep 5

fi
done