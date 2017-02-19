systemctl daemon-reload
service cpu-fan stop
insserv -r cpu-fan
rm -f /usr/bin/cpu-fan
rm -f /etc/init.d/cpu-fan
rm -f /etc/logrotate.d/cpu-fan
rm -f /var/log/cpu-fan/cpu-fan.log
rm -f -r /var/log/cpu-fan
rm -f ~/.cpu-fan.conf
