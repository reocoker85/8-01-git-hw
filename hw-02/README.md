# Домашнее задание к занятию "Обзор систем IT-мониторинга" - Комиссаров Игорь

---

### Задание 1

![1.jpg](https://github.com/reocoker85/8-01-git-hw/blob/main/hw-02/img/1.jpg)

```
wget https://repo.zabbix.com/zabbix/6.4/debian/pool/main/z/zabbix-release/zabbix-release_6.4-1+debian11_all.deb
dpkg -i zabbix-release_6.4-1+debian11_all.deb
apt update
apt install zabbix-server-pgsql zabbix-frontend-php php7.4-pgsql zabbix-apache-conf zabbix-sql-scripts
systemctl restart zabbix-server apache2
systemctl enable zabbix-server apache2
```

---

### Задание 2

![3.jpg](https://github.com/reocoker85/8-01-git-hw/blob/main/hw-02/img/3.jpg)
![2.jpg](https://github.com/reocoker85/8-01-git-hw/blob/main/hw-02/img/2.jpg)
![4.jpg](https://github.com/reocoker85/8-01-git-hw/blob/main/hw-02/img/4.jpg)

```
wget https://repo.zabbix.com/zabbix/6.4/debian/pool/main/z/zabbix-release/zabbix-release_6.4-1+debian11_all.deb
dpkg -i zabbix-release_6.4-1+debian11_all.deb
apt update
apt install zabbix-agent
systemctl restart zabbix-agent
systemctl enable zabbix-agent
```
---

### Задание 3
![9.jpg](https://github.com/reocoker85/8-01-git-hw/blob/main/hw-02/img/9.jpg)
