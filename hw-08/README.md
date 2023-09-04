# Домашнее задание к занятию "Резервное копирование" - Комиссаров Игорь


### Задание 1
- Составьте команду rsync, которая позволяет создавать зеркальную копию домашней директории пользователя в директорию `/tmp/backup`
- Необходимо исключить из синхронизации все директории, начинающиеся с точки (скрытые)
- Необходимо сделать так, чтобы rsync подсчитывал хэш-суммы для всех файлов, даже если их время модификации и размер идентичны в источнике и приемнике.
- На проверку направить скриншот с командой и результатом ее выполнения

![1.png](https://github.com/reocoker85/8-01-git-hw/blob/main/hw-08/img/1.png)

---

### Задание 2
- Написать скрипт и настроить задачу на регулярное резервное копирование домашней директории пользователя с помощью rsync и cron.
- Резервная копия должна быть полностью зеркальной
- Резервная копия должна создаваться раз в день, в системном логе должна появляться запись об успешном или неуспешном выполнении операции
- Резервная копия размещается локально, в директории `/tmp/backup`
- На проверку направить файл crontab и скриншот с результатом работы утилиты.

Bash-скрипт:

```
#!/bin/bash
if rsync -azc --delete /home/reocoker/ /tmp/backup/ ;then
  logger "Backup completed successfully"
else logger "Failed to backup" ;
fi;

```

Настраиваем cron:
![3.png](https://github.com/reocoker85/8-01-git-hw/blob/main/hw-08/img/3.png)

Проверяем лог:
![2.png](https://github.com/reocoker85/8-01-git-hw/blob/main/hw-08/img/2.png)

---

### Задание 3
- Настройте ограничение на используемую пропускную способность rsync до 1 Мбит/c
- Проверьте настройку, синхронизируя большой файл между двумя серверами
- На проверку направьте команду и результат ее выполнения в виде скриншота

![4.png](https://github.com/reocoker85/8-01-git-hw/blob/main/hw-08/img/4.png)

![5.png](https://github.com/reocoker85/8-01-git-hw/blob/main/hw-08/img/5.png)


---
### Задание 4*
- Напишите скрипт, который будет производить инкрементное резервное копирование домашней директории пользователя с помощью rsync на другой сервер
- Скрипт должен удалять старые резервные копии (сохранять только последние 5 штук)
- Напишите скрипт управления резервными копиями, в нем можно выбрать резервную копию и данные восстановятся к состоянию на момент создания данной резервной копии.
- На проверку направьте скрипт и скриншоты, демонстрирующие его работу в различных сценариях.

Bash-скрипт 1:

```
!/bin/bash
rsync -a --delete -e 'ssh' /home/reocoker/ reo2@10.0.2.7:/home/reo2/backup/full --backup --backup-dir=/home/reo2/backup/increment/$(date +%T)/
ssh reo2@10.0.2.7 -t 'cd /home/reo2/backup/increment/ ;
if [ $(ls | wc -l) -lt 5 ];then
  echo "Less"
else [ $(ls -t|awk "NR>5"|xargs rm -rf) ]
  echo "Deleted"
fi'

```

Список бэкапов на втрой машине:
![6.png](https://github.com/reocoker85/8-01-git-hw/blob/main/hw-08/img/6.png)

Запуск скрипта:
![7.png](https://github.com/reocoker85/8-01-git-hw/blob/main/hw-08/img/7.png)

Итог:
![8.png](https://github.com/reocoker85/8-01-git-hw/blob/main/hw-08/img/8.png)

Bash-скрипт 2:

```
#!/bin/bash
ssh reo2@10.0.2.7  'cd /home/reo2/backup/increment/
echo "Choose backup:"
ls
read choose
for folder in *;do
  if [[ $choose == $folder ]];then
     rsync -aP -e 'ssh' reo2@10.0.2.7:/home/reo2/backup/increment/$choose/ /home/reocoker/1/
  fi
done'

```
![9.png](https://github.com/reocoker85/8-01-git-hw/blob/main/hw-08/img/9.png)

![10.png](https://github.com/reocoker85/8-01-git-hw/blob/main/hw-08/img/10.png)
