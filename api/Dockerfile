FROM ruby:2.7.1


ENV RAILS_ENV production
# ENV RAILS_ENV development

EXPOSE 3000

RUN apt-get update -qq && \
  apt-get install -y build-essential \ 
  libpq-dev \        
  nodejs \
  && rm -rf /var/lib/apt/lists/* 

RUN mkdir /app
WORKDIR /app

# ADD ./Gemfile /app/Gemfile
# ADD ./Gemfile.lock /app/Gemfile.lock
COPY . .

RUN bundle install