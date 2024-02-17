FROM ruby:3.2.2-alpine

ENV RAILS_ROOT /app
ENV LANG C.UTF-8

WORKDIR $RAILS_ROOT

RUN apk update && \
    apk add --no-cache build-base sqlite-dev nodejs postgresql-dev
    

COPY . .
RUN gem install bundler && bundle install --jobs 20 --retry 5


ENTRYPOINT [ "/app/entrypoint/docker-entrypoint.sh" ]
CMD ["server"]