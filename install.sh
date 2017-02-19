cp cpu_fan.sh /usr/bin/cpu-fan
chmod 755 /usr/bin/cpu-fan
cp ./init.d/cpu-fan /etc/init.d/cpu-fan
chmod 755 /etc/init.d/cpu-fan
cp ./logrotate.d/cpu-fan /etc/logrotate.d/cpu-fan
mkdir /var/log/cpu-fan
chown root:root /var/log/cpu-fan
chmod 777 /var/log/cpu-fan
touch /var/log/cpu-fan/cpu-fan.log
chown root:root /var/log/cpu-fan/cpu-fan.log
chmod 666 /var/log/cpu-fan/cpu-fan.log
systemctl daemon-reload
insserv cpu-fan
service cpu-fan start