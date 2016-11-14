# grundstein/redis dockerfile
# VERSION 0.0.1

FROM alpine:3.4

MAINTAINER Wizards & Witches <dev@wiznwit.com>
ENV REFRESHED_AT 2016-14-11

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN addgroup -S redis && adduser -S -G redis redis

# grab su-exec for easy step-down from root
RUN apk add --no-cache su-exec

ENV REDIS_VERSION 3.2.5
ENV REDIS_DOWNLOAD_URL http://download.redis.io/releases/redis-3.2.5.tar.gz
ENV REDIS_DOWNLOAD_SHA1 6f6333db6111badaa74519d743589ac4635eba7a

# for redis-sentinel see: http://redis.io/topics/sentinel
RUN apk add --update ca-certificates curl gcc libc-dev make tar linux-headers && \
    mkdir -p /usr/src/redis && \
    curl -sSL "$REDIS_DOWNLOAD_URL" -o redis.tar.gz && \
    echo "$REDIS_DOWNLOAD_SHA1 *redis.tar.gz" | sha1sum -c - && \
    tar -xzf redis.tar.gz -C /usr/src/redis --strip-components=1 && \
    rm redis.tar.gz && \
    make -C /usr/src/redis MALLOC=libc && \
    make -C /usr/src/redis install && \
    rm -r /usr/src/redis && \
    apk del ca-certificates curl gcc libc-dev make tar linux-headers && \
    rm -rf /var/cache/apk/*

ARG PORT
ARG DIR

RUN mkdir ${DIR}/data && chown redis:redis ${DIR}/data
VOLUME ${DIR}/data
WORKDIR ${DIR}/data

# Define mountable directories.
VOLUME ${DIR}/data

COPY ./redis.conf /redis.conf

COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE ${PORT}
CMD [ "redis-server", "/redis.conf" ]
