# wizardsatwork/grundstein/redis dockerfile
# VERSION 0.0.1

FROM alpine:3.3

MAINTAINER Wizards & Witches <dev@wiznwit.com>
ENV REFRESHED_AT 2016-21-02

RUN echo "http://dl-4.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
RUN apk update && \
  apk add --update redis && rm -rf /var/cache/apk/*

RUN echo never > /sys/kernel/mm/transparent_hugepage/enabled

ARG DIR

COPY ./redis.conf /redis.conf

# Define mountable directories.
VOLUME ${DIR}/data

# Define working directory.
WORKDIR ${DIR}/data

# Define default command.
CMD ["redis-server", "/redis.conf"]

ARG PORT

# Expose ports.
EXPOSE ${PORT}
