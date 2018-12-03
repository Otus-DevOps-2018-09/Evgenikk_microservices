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
