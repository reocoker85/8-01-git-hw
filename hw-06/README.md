# Домашнее задание к занятию "Disaster recovery и Keepalived" - Комиссаров Игорь


### Задание 1

- Дана схема для Cisco Packet Tracer, рассматриваемая в лекции.
- На данной схеме уже настроено отслеживание интерфейсов маршрутизаторов Gi0/1 (для нулевой группы)
- Необходимо аналогично настроить отслеживание состояния интерфейсов Gi0/0 (для первой группы).
- Для проверки корректности настройки, разорвите один из кабелей между одним из маршрутизаторов и Switch0 и запустите ping между PC0 и Server0.
- На проверку отправьте получившуюся схему в формате pkt и скриншот, где виден процесс настройки маршрутизатора.

Схема в формате pkt:
[https://github.com/reocoker85/homework/commit/49e9785623030da051ded41b99475875cb464e15](https://github.com/reocoker85/homeworks/blob/main/hw-06/homework.pkt)]


![1.png](https://github.com/reocoker85/8-01-git-hw/blob/main/hw-06/img/1.png)

---

### Задание 2

- Запустите две виртуальные машины Linux, установите и настройте сервис Keepalived как в лекции, используя пример конфигурационного файла.
- Настройте любой веб-сервер (например, nginx или simple python server) на двух виртуальных машинах
- Напишите Bash-скрипт, который будет проверять доступность порта данного веб-сервера и существование файла index.html в root-директории данного веб-сервера.
- Настройте Keepalived так, чтобы он запускал данный скрипт каждые 3 секунды и переносил виртуальный IP на другой сервер, если bash-скрипт завершался с кодом, отличным от нуля (то есть порт веб-сервера был недоступен или отсутствовал index.html). Используйте для этого секцию vrrp_script
- На проверку отправьте получившейся bash-скрипт и конфигурационный файл keepalived, а также скриншот с демонстрацией переезда плавающего ip на другой сервер в случае недоступности порта или файла index.html

Bash-скрипт:

```
#!/bin/bash

if [[ -f /var/www/html/index.nginx-debian.html ]] && ( nc -zv 10.0.2.50 80 &> /dev/null ) ; then
    exit 0
else
    exit 1
fi;
```
Конфигурационный файл keepalived:
```
vrrp_script check {
       script "/etc/keepalived/check.sh"
       interval 3
}
vrrp_instance VI_1 {
        state MASTER
        interface enp0s3
        virtual_router_id 100
        priority 255
        advert_int 1


        virtual_ipaddress {
              10.0.2.50/24
        }


        track_script {
                   check
        }
}
```

![2.png](https://github.com/reocoker85/8-01-git-hw/blob/main/hw-06/img/2.png)

![3.png](https://github.com/reocoker85/8-01-git-hw/blob/main/hw-06/img/3.png)

---

### Задание 3

- Изучите дополнительно возможность Keepalived, которая называется vrrp_track_file
- Напишите bash-скрипт, который будет менять приоритет внутри файла в зависимости от нагрузки на виртуальную машину (можно разместить данный скрипт в cron и запускать каждую минуту). Рассчитывать приоритет можно, например, на основании Load average.
- Настройте Keepalived на отслеживание данного файла.
- Нагрузите одну из виртуальных машин, которая находится в состоянии MASTER и имеет активный виртуальный IP и проверьте, чтобы через некоторое время она перешла в состояние SLAVE из-за высокой нагрузки и виртуальный IP переехал на другой, менее нагруженный сервер.
- Попробуйте выполнить настройку keepalived на третьем сервере и скорректировать при необходимости формулу так, чтобы плавающий ip адрес всегда был прикреплен к серверу, имеющему наименьшую нагрузку.
- На проверку отправьте получившийся bash-скрипт и конфигурационный файл keepalived, а также скриншоты логов keepalived с серверов при разных нагрузках

Bash-скрипт:

```
#!/bin/bash

la=$(cat /proc/loadavg | cut -d ' ' -f 1)
la=$(bc<<<$la*100 | cut -d '.' -f 1)
if [[ $la -le 100 ]]; then
  echo $((100 -$la)) > /etc/keepalived/result.txt
else echo 1 > /etc/keepalived/result.txt;
fi;
```

Конфигурационный файл keepalived:
```
track_file result {
      file /etc/keepalived/result.txt
}

vrrp_instance VI_1 {
        state MASTER
        interface enp0s3
        virtual_router_id 100
        priority 150
        advert_int 1

        virtual_ipaddress {
              10.0.2.50/24
        }
        track_file {
              result weight 1
    }
}
```
Настраиваем cron:

![6.png](https://github.com/reocoker85/8-01-git-hw/blob/main/hw-06/img/6.png)

Результаты:

![4.png](https://github.com/reocoker85/8-01-git-hw/blob/main/hw-06/img/4.png)

![5.png](https://github.com/reocoker85/8-01-git-hw/blob/main/hw-06/img/5.png)


