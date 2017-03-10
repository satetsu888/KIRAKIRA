FROM debian:jessie

RUN apt-get install -y \
        build-essential \
        mysql-client \
        memcached \
        curl \
        cpanminus

ENV APP_DIR=/var/app

ADD . $APP_DIR
WORKDIR $APP_DIR

RUN cpanm --installdeps . --notest

EXPOSE 3000

CMD starman app.pl --port 3000
