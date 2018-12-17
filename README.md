# Evgenikk_microservices
Evgenikk microservices repository

### Docker-1
Установили Docker
Запустили контейнер hello world
Запускали и "знакомились" с командами docker ps,  images,  run, start, attach, exec
Сделали commit контейнера
Проанализировали различия между контейнером и образом
Воспользовались docker kill, docker rm, docker rmi для остановки и удаления контейнеров, а так же образов

### Docker-2
При запуске "docker run --rm --pid host -ti tehbilly/htop" --pid позволяет контейнеру видеть процессы хостовой системы

В работе написали Dockerfile  для создания контейнера с приложением, развернули его на локальной машине, загрузили на Docker hub, использовали Docker-machine и развернули приложение в контейнере на хосте GCP.

Написали docker-eng.json для Packer, генерирующий шаблон с установленным Docker, python, pip
При помощи Terraform организовали развертывание заданного числа инстансов на основе шаблона docker-reddit с открытием необходимых портов
Написали playbook для билда и запуска контейнера

Для запуска проекта из корня репозитория выполнить:
```
cd docker-monolith/infra/
packer build -var-file=packer/variables.json packer/docker-eng.json 
cd terraform && terraform init && terraform get && terraform apply  
cd ../ansible 
ansible-playbook playbooks/terraform.yml #предварительно необходимо задать параметры подключения для  ansible и ip хостов в inventory
```

### Docker-3
Написали 3 Dockerfile, описывающие 3 контейнера для развертывания reddit в виде микросервисной архитектуры
Создали bridge сеть для контейнеров
Запустили контейнеры и соединили их в сети
Повторили запуск контейнеров, но с передачей переменных окружения через docker run:
```
docker run -d --network=reddit --network-alias=post_db_serv \
     --network-alias=comment_db_serv mongo:latest

docker run -d --network=reddit  \
 --network-alias=post_serv \
 -e POST_DATABASE_HOST='post_db_serv' \
 -e POST_DATABASE='post_serv' \
 batcake/post:1.0

 docker run -d --network=reddit  \
 --network-alias=comment_serv \
 -e COMMENT_DATABASE_HOST='comment_db_serv' \
 -e COMMENT_DATABASE='comment_serv' batcake/comment:1.0

 docker run -d --network=reddit -p 9292:9292 \
 -e POST_SERVICE_HOST='post_serv' \
 -e COMMENT_SERVICE_HOST='comment_serv' batcake/ui:1.0
 ```
Оптимизировали размер образа ui
Сделали образ ui на базе alpine
Создали том с базой данных для монго и подключили его к контейнеру

### Docker-4

Узнайте как образуется базовое имя проекта. Можно
ли его задать? Если можно то как?

Имя по умолчанию задается в соответсвии с дирректорией из которой запущен docker-compose
Для задания произвольного значения:
```
docker-compose -p MY_PROJECT up -d
```

В ходе работы:
Использовали способы взаимодействия контейнеров с сетью
Распределелили микросервисы по двум bridge сетям и организовали их взаимодействие
Использовали Docker-compose  для развертывания приложения в одной bridge сети
Параметризовали Docker-compose.yml 
Изменили Docker-compose.yml таким образом, чтобы бд контейнер был  в back_net
Создали  Docker-compose.override.yml. Он позволяет изменять код без пересборки контейнера, а также запускает puma в debug режиме.

