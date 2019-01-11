default_build: post comment ui prometheus cloudprober push
push: push_comment push_post push_ui push_prometheus push_cloudprober

post: 
	cd src/post-py && bash docker_build.sh
comment: 
	cd src/comment && bash docker_build.sh
ui: 
	cd src/ui && bash docker_build.sh

prometheus:
	cd monitoring/prometheus && docker build -t ${USER_NAME}/prometheus .
cloudprober:
	cd monitoring/cloudprober && docker build -t ${USER_NAME}/cloudprober .

push_post:
	docker push ${USER_NAME}/post
push_comment:
	docker push ${USER_NAME}/comment
push_ui:
	docker push ${USER_NAME}/ui

push_cloudprober:
	docker push ${USER_NAME}/cloudprober
push_prometheus:
	docker push ${USER_NAME}/prometheus

