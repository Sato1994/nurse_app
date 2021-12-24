FROM ruby:2.7.1

ARG WEB_WORKDIR


RUN apt-get update -qq && \
  apt-get install -y build-essential \ 
  libpq-dev \        
  nodejs \
  && rm -rf /var/lib/apt/lists/* 

RUN mkdir ${WEB_WORKDIR}
WORKDIR ${WEB_WORKDIR}

ADD ./Gemfile ${WEB_WORKDIR}/Gemfile
ADD ./Gemfile.lock ${WEB_WORKDIR}/Gemfile.lock

RUN bundle install
