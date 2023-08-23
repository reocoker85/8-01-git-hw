# Домашнее задание к занятию "Кластеризация и балансировка нагрузки" - Комиссаров Игорь


### Задание 1

- Запустите два simple python сервера на своей виртуальной машине на разных портах
- Установите и настройте HAProxy, воспользуйтесь материалами к лекции по ссылке
- Настройте балансировку Round-robin на 4 уровне.
- На проверку направьте конфигурационный файл haproxy, скриншоты, где видно перенаправление запросов на разные серверы при обращении к HAProxy.

![1.png](https://github.com/reocoker85/8-01-git-hw/blob/main/hw-07/img/1.png)

![2.png](https://github.com/reocoker85/8-01-git-hw/blob/main/hw-07/img/2.png)

---

### Задание 2

```
frontend example  # секция фронтенд
        mode http
        bind :8088
        #default_backend web_servers
        acl ACL_example.com hdr(host) -i example.com
        use_backend web_servers if ACL_example.com

backend web_servers    # секция бэкенд
        mode http
        balance roundrobin
        option httpchk
        http-check send meth GET uri /index.html
        server s1 127.0.0.1:7777 weight 2 check
        server s2 127.0.0.1:8888 weight 3 check
        server s3 127.0.0.1:9999 weight 4 check

```

![3.png](https://github.com/reocoker85/8-01-git-hw/blob/main/hw-07/img/3.png)

![4.png](https://github.com/reocoker85/8-01-git-hw/blob/main/hw-07/img/4.png)

---

### Задание 3


```
include /etc/nginx/include/upstream.inc;

server {
   listen       80;


   server_name  example-http.com;


   access_log   /var/log/nginx/example-http.com-acess.log;
   error_log    /var/log/nginx/example-http.com-error.log;

   location / {
                proxy_pass      http://localhost:8088;

   }
   location ~ \.(jpg)$ {
            root /var/www;
   }
}


```

![5.png](https://github.com/reocoker85/8-01-git-hw/blob/main/hw-07/img/5.png)

---

### Задание 4

```
frontend example  # секция фронтенд
        mode http
        bind :8088
        #default_backend web_servers
        acl ACL_example1.com hdr(host) -i example1.com
        acl ACL_example2.com hdr(host) -i example2.com
        use_backend web_servers1 if ACL_example1.com
        use_backend web_servers2 if ACL_example2.com

backend web_servers1    # секция бэкенд
        mode http
        balance roundrobin
        option httpchk
        http-check send meth GET uri /index.html
        server s1 127.0.0.1:7777 check
        server s2 127.0.0.1:8888 check

backend web_servers2    # секция бэкенд
        mode http
        balance roundrobin
        option httpchk
        http-check send meth GET uri /index.html
        server s3 127.0.0.1:9999 check
        server s4 127.0.0.1:11111 check

```

![7.png](https://github.com/reocoker85/8-01-git-hw/blob/main/hw-07/img/7.png)

![8.png](https://github.com/reocoker85/8-01-git-hw/blob/main/hw-07/img/8.png)
