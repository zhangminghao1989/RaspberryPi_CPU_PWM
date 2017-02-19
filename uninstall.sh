sudo systemctl daemon-reload
sudo service cpu-fan stop
sudo insserv -r cpu-fan
sudo rm -f /usr/bin/cpu-fan
sudo rm -f /etc/init.d/cpu-fan
sudo rm -f /etc/logrotate.d/cpu-fan
sudo rm -f /var/log/cpu-fan/cpu-fan.log
sudo rm -f -r /var/log/cpu-fan
rm -f ~/.cpu-fan.conf
#sed -i '/sudo service cpu-fan start/'d ~/.profile