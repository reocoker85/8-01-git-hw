# Домашнее задание к занятию "Что такое DevOps. СI/СD" - Комиссаров Игорь

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


