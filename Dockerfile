
ARG IMAGE_ARG_IMAGE_TAG

FROM mysql:${IMAGE_ARG_IMAGE_TAG:-5.6.40} as base

# see https://github.com/mysql/mysql-docker/blob/mysql-server/5.6/Dockerfile
# see https://github.com/mysql/mysql-docker/blob/mysql-server/5.7/Dockerfile

FROM scratch

ARG IMAGE_ARG_APT_MIRROR

COPY --from=base / /

RUN set -ex \
  && usermod -u 1000  mysql \
  && groupmod -g 1000 mysql \
  && find -user 999 -path "/proc" -prune -exec chown mysql:mysql {} ";" \
  && chown -hR mysql:mysql /var/log/mysql /etc/mysql

# -------------------- Locale --------------------

#ENV DEBIAN_FRONTEND noninteractive
#ENV DEBCONF_NONINTERACTIVE_SEEN true

# apt-get -qy purge tzdata locales debconf can not or should not be removed
#&& echo "deb http://ftp.jp.debian.org/debian sid main" > /etc/apt/sources.list \
COPY docker/debconf.txt /etc/debconf.txt
RUN set -ex \
  && sed -i "s/http:\/\/deb.debian.org\/debian/http:\/\/${IMAGE_ARG_APT_MIRROR:-cdn-fastly.deb.debian.org}\/debian/g" /etc/apt/sources.list \
  && wget -O /tmp/RPM-GPG-KEY-mysql https://repo.mysql.com/RPM-GPG-KEY-mysql \
  && apt-key add /tmp/RPM-GPG-KEY-mysql \
  && apt-key list \
  && echo /etc/apt/sources.list \
  && cat /etc/apt/sources.list \
  && apt -y update \
  && apt -q -y install --reinstall locales tzdata debconf \
  && debconf-set-selections /etc/debconf.txt \
  && echo "Asia/Shanghai" > /etc/timezone \
  && dpkg-reconfigure -f noninteractive tzdata \
  && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
  && dpkg-reconfigure -f noninteractive locales \
  && apt -q -y autoremove \
  && apt -y clean

ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# -------------------- Locale --------------------

VOLUME ["/var/lib/mysql", "/var/log/mysql"]
ENTRYPOINT ["/entrypoint.sh"]
HEALTHCHECK CMD /healthcheck.sh
EXPOSE 3306
CMD ["mysqld"]