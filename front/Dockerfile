FROM node:14.16.1-alpine

ARG FRONT_WORKDIR

RUN mkdir -p ${FRONT_WORKDIR}
WORKDIR ${FRONT_WORKDIR}
# EXPOSE 3000
# ENV HOST 0.0.0.0

# コマンド実行
RUN apk update && \
  apk add git