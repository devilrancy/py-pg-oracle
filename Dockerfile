FROM python:2.7-alpine

MAINTAINER Surisetty, Naresh <naresh@naresh.co>

USER root

COPY oracle.zip /tmp/

RUN mkdir /etc/ld.so.conf.d

ENV ORACLE_HOME=/usr/lib/oracle/12.1/client64
ENV PATH=$PATH:$ORACLE_HOME/bin
ENV LD_LIBRARY_PATH=$ORACLE_HOME/lib

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
        && ln -s $ORACLE_HOME/lib/libclntsh.so.12.1 $ORACLE_HOME/lib/libclntsh.so \
        && pip --no-cache-dir install \
                psycopg2 \
                cx_Oracle \
        && apk del .build-deps
