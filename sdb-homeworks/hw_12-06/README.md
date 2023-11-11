# Домашнее задание к занятию «Репликация и масштабирование. Часть 1»


### Задание 1

На лекции рассматривались режимы репликации master-slave, master-master, опишите их различия.

*Ответить в свободной форме.*

---

### Задание 2

Выполните конфигурацию master-slave репликации, примером можно пользоваться из лекции.

*Приложите скриншоты конфигурации, выполнения работы: состояния и режимы работы серверов.*

### Решение 2

Используя [vagrant](./vagrantfile), создадим 2 ВМ:

db1 - 192.168.0.10 - master
db2 - 192.168.0.11 - slave

Внесем изменения в /etc/mysql/mysql.conf.d/mysqld.cnf на обоих северах:

```
Master server:                                                 Slave sever:

[mysqld]                                                       [mysqld]
pid-file = /var/run/mysqld/mysqld.pid                          pid-file = /var/run/mysqld/mysqld.pid
socket = /var/run/mysqld/mysqld.sock                           socket = /var/run/mysqld/mysqld.sock
datadir = /var/lib/mysql                                       bind-address = 0.0.0.0
bind-address = 0.0.0.0  
log_error = /var/log/mysql/error.log
server-id = 1
log_bin = /var/log/mysql/mysql-bin.log
max_binlog_size = 500M
slow_query_log = 1
```

---

## Дополнительные задания (со звёздочкой*)
Эти задания дополнительные, то есть не обязательные к выполнению, и никак не повлияют на получение вами зачёта по этому домашнему заданию. Вы можете их выполнить, если хотите глубже шире разобраться в материале.

---

### Задание 3* 

Выполните конфигурацию master-master репликации. Произведите проверку.

*Приложите скриншоты конфигурации, выполнения работы: состояния и режимы работы серверов.*
