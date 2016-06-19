FROM ruby:2.2.4

RUN gem install jekyll --no-rdoc --no-ri
RUN gem install redcarpet --no-rdoc --no-ri

EXPOSE 4000

WORKDIR /docs
