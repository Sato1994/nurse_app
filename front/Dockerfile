FROM node:14.16.1-alpine

ENV APP_HOME /app
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME
# EXPOSE 3000
# ENV HOST 0.0.0.0

# コマンド実行
RUN apk update && \
  apk add git && \
  npm install -g @vue/cli nuxt create-nuxt-app