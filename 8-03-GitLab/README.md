# Домашнее задание к занятию "GitLab" - Комиссаров Игорь

---

Задание 1

1.Разверните GitLab локально, используя Vagrantfile и инструкцию, описанные в этом репозитории.\n
2.Создайте новый проект и пустой репозиторий в нём.
3.Зарегистрируйте gitlab-runner для этого проекта и запустите его в режиме Docker. Раннер можно регистрировать и запускать на той же виртуальной машине, на которой запущен GitLab.
4.В качестве ответа в репозиторий шаблона с решением добавьте скриншоты с настройками раннера в проекте.

![3.png](https://github.com/reocoker85/8-01-git-hw/blob/main/8-03-GitLab/img/3.png)
![1.png](https://github.com/reocoker85/8-01-git-hw/blob/main/8-03-GitLab/img/1.png)
![2.png](https://github.com/reocoker85/8-01-git-hw/blob/main/8-03-GitLab/img/2.png)
---

Задание 2

Что нужно сделать:

Запушьте репозиторий на GitLab, изменив origin. Это изучалось на занятии по Git.
Создайте .gitlab-ci.yml, описав в нём все необходимые, на ваш взгляд, этапы.
В качестве ответа в шаблон с решением добавьте:

файл gitlab-ci.yml для своего проекта или вставьте код в соответствующее поле в шаблоне;
скриншоты с успешно собранными сборками.

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

Измените CI так, чтобы:

этап сборки запускался сразу, не дожидаясь результатов тестов;
тесты запускались только при изменении файлов с расширением *.go.
В качестве ответа добавьте в шаблон с решением файл gitlab-ci.yml своего проекта или вставьте код в соответсвующее поле в шаблоне.
```
stages:
  - test
  - build

test:
  stage: test
  image: golang:1.17
  script:
   - go test .

build:
  stage: build
  needs: []
  image: docker:latest
  script:
   - docker build .
```
```
stages:
  - test
  - build

test:
  stage: test
  rules:
   - changes:
      - "*.go"
  image: golang:1.17
  script:
   - go test .

build:
  stage: build
  image: docker:latest
  script:
   - docker build .
```


---


