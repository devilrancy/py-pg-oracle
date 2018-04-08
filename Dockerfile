FROM python:2.7-alpine

MAINTAINER Surisetty, Naresh <naresh@naresh.co>

COPY oracle.zip /tmp/

ADD oracle.conf /etc/ld.so.conf.d/oracle.conf
ADD oracle.sh /etc/profile.d/oracle.sh
RUN chmod o+r /etc/ld.so.conf.d/oracle.conf
RUN chmod o+r /etc/profile.d/oracle.sh

RUN set -ex \
        && apk add --no-cache --virtual .run-deps \
                bash \
                postgresql \
                postgresql-libs \
        && apk add --no-cache --virtual .build-deps \
                gcc \
                g++ \
                unzip \
                libc-dev \
                unixodbc-dev \
                musl-dev \
                openssl \
                postgresql-dev \
        && mkdir -p /opt/oracle \
        && unzip "/tmp/oracle.zip" -d /usr/lib/ \
        && /etc/profile.d/oracle.sh \
        && ldconfig \
        && pip --no-cache-dir install \
                psycopg2 \
                cx_Oracle \
        && apk del .build-deps
