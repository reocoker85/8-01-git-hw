# Домашнее задание к занятию "Что такое DevOps. СI/СD" - Комиссаров Игорь


### Инструкция по выполнению домашнего задания

   1. Сделайте `fork` данного репозитория к себе в Github и переименуйте его по названию или номеру занятия, например, https://github.com/имя-вашего-репозитория/git-hw или  https://github.com/имя-вашего-репозитория/7-1-ansible-hw).
   2. Выполните клонирование данного репозитория к себе на ПК с помощью команды `git clone`.
   3. Выполните домашнее задание и заполните у себя локально этот файл README.md:
      - впишите вверху название занятия и вашу фамилию и имя
      - в каждом задании добавьте решение в требуемом виде (текст/код/скриншоты/ссылка)
      - для корректного добавления скриншотов воспользуйтесь [инструкцией "Как вставить скриншот в шаблон с решением](https://github.com/netology-code/sys-pattern-homework/blob/main/screen-instruction.md)
      - при оформлении используйте возможности языка разметки md (коротко об этом можно посмотреть в [инструкции  по MarkDown](https://github.com/netology-code/sys-pattern-homework/blob/main/md-instruction.md))
   4. После завершения работы над домашним заданием сделайте коммит (`git commit -m "comment"`) и отправьте его на Github (`git push origin`);
   5. Для проверки домашнего задания преподавателем в личном кабинете прикрепите и отправьте ссылку на решение в виде md-файла в вашем Github.
   6. Любые вопросы по выполнению заданий спрашивайте в чате учебной группы и/или в разделе “Вопросы по заданию” в личном кабинете.
   
Желаем успехов в выполнении домашнего задания!
   
### Дополнительные материалы, которые могут быть полезны для выполнения задания

1. [Руководство по оформлению Markdown файлов](https://gist.github.com/Jekins/2bf2d0638163f1294637#Code)

---

Задание 1

 Установите себе jenkins по инструкции из лекции или любым другим способом из официальной документации. Использовать Docker в этом задании нежелательно.
 Установите на машину с jenkins golang.
 Используя свой аккаунт на GitHub, сделайте себе форк репозитория. В этом же репозитории находится дополнительный материал для выполнения ДЗ.
 Создайте в jenkins Freestyle Project, подключите получившийся репозиторий к нему и произведите запуск тестов и сборку проекта go test . и docker build ..

В качестве ответа пришлите скриншоты с настройками проекта и результатами выполнения сборки.

![Screenshot_1.jpg](https://github.com/reocoker85/8-01-git-hw/blob/main/8-02-CICD-hw/img/Screenshot_1.jpg)
![Screenshot_2.jpg](https://github.com/reocoker85/8-01-git-hw/blob/main/8-02-CICD-hw/img/Screenshot_2.jpg)
![Screenshot_3.jpg](https://github.com/reocoker85/8-01-git-hw/blob/main/8-02-CICD-hw/img/Screenshot_3.jpg)
---

Задание 2

Что нужно сделать:

Создайте новый проект pipeline.
Перепишите сборку из задания 1 на declarative в виде кода.
В качестве ответа пришлите скриншоты с настройками проекта и результатами выполнения сборки.

```
pipeline {
 agent any
 stages {
  stage('Git') {
   steps {git 'https://github.com/reocoker85/sdvps-materials.git'
           branch 'main'}
  }
  stage('Test') {
   steps {
    sh '/usr/local/go/bin/go test .'
   }
  }
  stage('Build') {
   steps {
    sh 'docker build . -t ubuntu-bionic:8082/hello-world:v$BUILD_NUMBER'
   }
  }
 }
}
```

![Screenshot_4.jpg](https://github.com/reocoker85/8-01-git-hw/blob/main/8-02-CICD-hw/img/Screenshot_4.jpg)


---

Задание 3

Что нужно сделать:

Установите на машину Nexus.
Создайте raw-hosted репозиторий.
Измените pipeline так, чтобы вместо Docker-образа собирался бинарный go-файл. Команду можно скопировать из Dockerfile.
Загрузите файл в репозиторий с помощью jenkins.
В качестве ответа пришлите скриншоты с настройками проекта и результатами выполнения сборки.
```
pipeline {
 agent any
 stages {
  stage('Git') {
   steps {git 'https://github.com/reocoker85/sdvps-materials.git'
           branch 'main'}
  }
  stage('Test') {
   steps {
    sh '/usr/local/go/bin/go test .'
   }
  }
  stage('Build') {
   steps {
    sh '/usr/local/go/bin/go build -o hello-world .'
    archiveArtifacts artifacts: '**/hello-world' , fingerprint: true
   }
  }
  stage('Push') {
   steps {
    sh 'curl -v -u admin:ae37bn67 --upload-file hello-world  http://51.250.86.130:8081/repository/my_repo/hello-world '
   }
  }
 }
}
```

![Screenshot_5.jpg](https://github.com/reocoker85/8-01-git-hw/blob/main/8-02-CICD-hw/img/Screenshot_5.jpg)
![Screenshot_6.jpg](https://github.com/reocoker85/8-01-git-hw/blob/main/8-02-CICD-hw/img/Screenshot_6.jpg)

---


