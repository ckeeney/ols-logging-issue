FROM litespeedtech/openlitespeed:1.8.5-lsphp85 as base
COPY ./php-error.php /usr/local/lsws/Example/html/php-error.php

FROM base as stderr
RUN sed -i -E 's!errorlog.*!errorlog stderr {! ' /usr/local/lsws/conf/vhosts/Example/vhconf.conf
RUN sed -i -E 's!accesslog.*!accesslog stdout {! ' /usr/local/lsws/conf/vhosts/Example/vhconf.conf

FROM base as dev-stderr
RUN sed -i -E 's!errorlog.*!errorlog /dev/stderr {! ' /usr/local/lsws/conf/vhosts/Example/vhconf.conf
RUN sed -i -E 's!accesslog.*!accesslog /dev/stdout {! ' /usr/local/lsws/conf/vhosts/Example/vhconf.conf
