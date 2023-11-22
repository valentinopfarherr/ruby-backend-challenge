FROM ruby:3.0

WORKDIR /app

COPY . /app

RUN gem install bundler
RUN bundle install

EXPOSE 9292

CMD ["bundle", "exec", "puma", "-b", "tcp://0.0.0.0:9292"]
