FROM node:14.16.1-alpine

ENV APP_HOME /app
RUN mkdir -p $APP_HOME
WORKDIR ${APP_HOME}

RUN apk update 
+ COPY package.json .
+ RUN npm install