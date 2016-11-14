# grundstein/redis dockerfile
# VERSION 0.0.1

FROM alpine:3.4

MAINTAINER Wizards & Witches <dev@wiznwit.com>
ENV REFRESHED_AT 2016-14-11

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN addgroup -S redis && adduser -S -G redis redis

# grab su-exec for easy step-down from root
# install redis
RUN apk update \
    && apk add su-exec redis \
    && rm -rf /var/cache/apk/*


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
