FROM node:14.16.1-alpine

# ARG FRONT_WORKDIR

RUN mkdir -p /app
WORKDIR /app
EXPOSE 8080
ENV HOST 0.0.0.0

COPY . .
# コマンド実行
RUN apk update && \
  apk add git