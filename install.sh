sudo service cpu-fan stop
sudo cp -f cpu-fan.sh /usr/bin/cpu-fan
sudo chmod 755 /usr/bin/cpu-fan
sudo cp -f ./init.d/cpu-fan /etc/init.d/cpu-fan
sudo chmod 755 /etc/init.d/cpu-fan
sudo cp -f ./logrotate.d/cpu-fan /etc/logrotate.d/cpu-fan
if [ ! -d "/var/log/cpu-fan" ];then
sudo mkdir /var/log/cpu-fan
fi
sudo chown root:root /var/log/cpu-fan
sudo chmod 777 /var/log/cpu-fan
sudo touch /var/log/cpu-fan/cpu-fan.log
sudo chown root:root /var/log/cpu-fan/cpu-fan.log
sudo chmod 666 /var/log/cpu-fan/cpu-fan.log
cp -n .cpu-fan.conf ~/.cpu-fan.conf
sudo systemctl daemon-reload
sudo insserv cpu-fan
sudo service cpu-fan start

