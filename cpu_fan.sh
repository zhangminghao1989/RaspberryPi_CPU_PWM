#!/bin/sh

#sleep 5
#设置运行状态文件
RUN=/var/run/cpu-fan.run
touch $RUN
chmod 777 $RUN
#设置风扇默认运行模式，0为关闭，1为全速，2为自动，运行过程中可以直接修改/var/run/cpu-fan.run文件来生效
echo "2" > $RUN
#设置开启风扇的最低温度
set_temp_min=35000
#设置风扇全速运行的温度
set_temp_max=70000

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
status=`cat $RUN`

#计算pwm值，从变量set_temp_min设置的温度开始开启风扇，最低转速50%
pwm=$((($tmp-$set_temp_min)*512/($set_temp_max-$set_temp_min)+511))

#设置pwm值上限
if [ $pwm -gt 1023 ] ;then
pwm=1023
fi


#小于设置温度关闭风扇
if [ $tmp -le $set_temp_min ] ;then
pwm=0
fan=0
else

#第一次超过设置温度全速开启风扇，防止风扇不能启动
if [ $tmp -gt $set_temp_min ] && [ $fan -eq 0 ] ;then
gpio pwm 1 1023
fan=1
sleep 5
fi
fi


#检查run文件，为0时关闭风扇
if [ $status -eq 0 ] ;then
pwm=0
fan=0
else

#检查run文件，为1时持续开启风扇最高转速
if [ $status -eq 1 ] ;then
pwm=1023
fi
fi

gpio pwm 1 $pwm

#每5秒钟检查一次温度
sleep 5

#输出日志
echo "`date` temp=$tmp  pwm=$pwm status=$status" >> /var/log/cpu-fan/cpu-fan.log
done