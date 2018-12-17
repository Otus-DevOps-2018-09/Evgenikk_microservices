FROM ruby:2.4.5-alpine3.8

ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME
COPY . $APP_HOME

RUN apk --no-cache add --virtual build-tools ruby-dev g++ make ruby-bundler \ 
&& bundle install && apk del build-tools 

ENV POST_SERVICE_HOST post
ENV POST_SERVICE_PORT 5000
ENV COMMENT_SERVICE_HOST comment
ENV COMMENT_SERVICE_PORT 9292
CMD ["puma"]

