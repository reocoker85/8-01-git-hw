#!/bin/bash

sudo apt update
sudo apt install nginx -y
ip=$(hostname -I)
sudo sed -i  "14 s/nginx/$ip/g" /var/www/html/index.nginx-debian.html
sudo service nginx start
