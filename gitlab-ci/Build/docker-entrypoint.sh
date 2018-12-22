#!/bin/bash
set -ex
usr/bin/gitlab-runner register \
 --non-interactive \
 --executor "docker" \
 --docker-image alpine:latest \
 --url $GITLAB_URL \
 --registration-token $TOKEN\
 --description "docker-runner" run-untagged locked="false"
gitlab-runner run --user=gitlab-runner --working-directory=/home/gitlab-runner
exec "$@"
