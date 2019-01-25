# Evgenikk_microservices
Evgenikk microservices repository
 gcloud compute firewall-rules create <name> --allow tcp:8080


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

### Gitlab-ci-1
/gitlab-ci/Build содержит скрипт и Dockerfile, используемых при создании образа batcake/gitlab-reg-runner. Данный образ при запуске регестрирует и запускает runner. Для этого при запуске нужно подключеить volume и задать значения переменных окружения TOKEN и GITLAB_URL

/gitlab-ci/Deploy/add_runner.yml запускает дополнительный gitlab-runner используя образ описанный выше, загруженный из docker hub.

В ходе работы был развернут gitlab, и настроены автотесты

### Gitlab-ci-2
Создали еще один проект и добавили в него runner из другого
Добавили dev, staging, prod  окружения. 
В stage и prod  окружениях сделали запуск "по кнопке". Добавили условие на наличие тэга.
Настроили динамическое окружение для каждой новой ветки.

### Monitoring-1
:9292 -reddit
:9090 -prometheus
:8080 -cAdvisor
:3000 -Grafana
:9093 -Alertmanager

Развернули Prometheus reddit app при помощи docker-compose
Посмотрели данные различных heathchecks в Prometheus
Использовали Node exporter для мониторинга виртуальной машины
Сделали push в dockerhub контейнеров prometheus, ui, post, comment

Использовали percona/mongodb_exporter для мониторинга mongodb. В monitoring/mongo-exporter/Dockerfile описан multistage build, в котором для формирования бинарного файла используется образ golang;

Реализовали blackbox мониторинг сервисов comment,post,ui. Для реализации blackbox мониторинга, использовался google/cloudprober. Конфигурация cloudprober: /monitoring/cloudprober/cloudprober.cfg

Написали Makefile для того, чтобы делать build и push всех используемых в лабораторной работе контейнеров
ссылки на образы в dockerhub:
```
https://cloud.docker.com/u/batcake/repository/docker/batcake/ui
https://cloud.docker.com/u/batcake/repository/docker/batcake/post
https://cloud.docker.com/u/batcake/repository/docker/batcake/comment

https://cloud.docker.com/u/batcake/repository/docker/batcake/cloudprober
https://cloud.docker.com/u/batcake/repository/docker/batcake/prometheus
https://cloud.docker.com/repository/docker/batcake/mongod_exporter
```
### Monitoring-2
Установили grafana
Использовали готовый dashbord для мониторинга Docker и системы
Создали свой dashbord для мониторинга  ui
Добавили график количества запросов к UI, использовали rate для наблюдения изменения количества запросов и запросов с неверным адресом за единицу времени
Добавили график с 95 процентилем времени ответа на запрос
Создали dashbord с бизнес метриками
Настроили alertmanager для отправки в slack сообщений в случае недоступности одной из наблюдаемых систем

Дополнили Makefile
Добавили в prometheus сбор метрик с докера. Для этого необходимо так же на хостовой машине в папку /etc/docker/ скопировать файл monitoring/store/daemon.json
Добавили  alert на значение 95ого процентиля задержки ответа
Настроили уведомления через почту в alertmanager

https://cloud.docker.com/u/batcake/repository/docker/batcake/alertmanager

### Logging-1
```
5601 - kibana
5140 - fluentd
9410 - zipkin
grok:https://github.com/elastic/logstash/blob/v1.4.2/patterns/grok-patterns
sudo sysctl -w vm.max_map_count=262144 - устраняет проблему с запуском elasticsearch
```

Поднят EFK стэк
Использован fluentd для обработки логов в формате json
Составили конфигурацию fluentd для обработки обоих форматов лог сообщений от UI сервиса
Развернут Zipkin и с его помощью выполнена трассировка запросов

### Kubernetes-1

Выполнили все задания из https://github.com/kelseyhightower/kubernetes-the-hard-way/tree/master/docs
Развернули post ui mongo и comment сервисы при помощи kubernetes

❯❯❯ kubectl get pods
NAME                                  READY     STATUS    RESTARTS   AGE
busybox-bd8fb7cbd-v5ckc               1/1       Running   0          19m
comment-deployment-554c5d68db-p6bqc   1/1       Running   0          1m
mongo-deployment-67f58fb89-w45d7      1/1       Running   0          1m
nginx-dbddb74b8-4zdvz                 1/1       Running   0          16m
post-deployment-b668dc698-dskjf       1/1       Running   0          51s
ui-deployment-5796679cb-rnxcd         1/1       Running   0          41s
untrusted                             1/1       Running   0          9m


### Kubernetes-1

Для доступа  ui использовал эту ссылку из-за неверной версии kubernetes:
http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/#!/login

Развернули локальное окружение для работы с Kubernetes и использовали его для разворачивания reddit app
Резвернули  kubernetes в GKE, развернули  reddit в  dev namespace
Использовали terraform для автоматизации развертывания кластера kubernetes