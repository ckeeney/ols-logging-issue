FROM litespeedtech/openlitespeed:1.8.5-lsphp85 AS base

# copy the prerelease build
ADD openlitespeed-1.8.5-x86_64-linux.tgz /usr/local/lsws/

# copy a php file that generates an error.
COPY ./php-error.php /usr/local/lsws/Example/html/php-error.php

# remove log rolling
# enableStderrLog
RUN sed -i \
    -e 's/rollingSize.*// ' \
    -e '/logLevel/a         enableStderrLog        1' \
    /usr/local/lsws/conf/httpd_config.conf \
    /usr/local/lsws/conf/vhosts/Example/vhconf.conf

# send all the logs to stderr
FROM base AS stderr
RUN sed -i \
    -e 's!accessLog.*!accessLog stderr {! ' \
    -e 's!errorlog.*!errorlog stderr {! ' \
    /usr/local/lsws/conf/httpd_config.conf \
    /usr/local/lsws/conf/vhosts/Example/vhconf.conf

# send all the logs to stdout
FROM base AS stdout
RUN sed -i \
    -e 's!accessLog.*!accessLog stdout {! ' \
    -e 's!errorlog.*!errorlog stdout {! ' \
    /usr/local/lsws/conf/httpd_config.conf \
    /usr/local/lsws/conf/vhosts/Example/vhconf.conf
