FROM registry.access.redhat.com/ubi9/s2i-base:1-530.1729766754

# This image provides an Apache+PHP environment for running PHP
# applications.

EXPOSE 8080
EXPOSE 8443

# Description
# This image provides an Apache 2.4 + PHP 8.0 environment for running PHP applications.
# Exposed ports:
# * 8080 - alternative port for http

ENV PHP_VERSION=8.3 \
    PHP_VER_SHORT=83 \
    NAME=php

ENV SUMMARY="Platform for building and running PHP $PHP_VERSION applications" \
    DESCRIPTION="PHP $PHP_VERSION available as container is a base platform for \
building and running various PHP $PHP_VERSION applications and frameworks. \
PHP is an HTML-embedded scripting language. PHP attempts to make it easy for developers \
to write dynamically generated web pages. PHP also offers built-in database integration \
for several commercial and non-commercial database management systems, so writing \
a database-enabled webpage with PHP is fairly simple. The most common use of PHP coding \
is probably as a replacement for CGI scripts."

LABEL summary="${SUMMARY}" \
      description="${DESCRIPTION}" \
      io.k8s.description="${DESCRIPTION}" \
      io.k8s.display-name="Apache 2.4 with PHP ${PHP_VERSION}" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,${NAME},${NAME}${PHP_VER_SHORT},${NAME}-${PHP_VER_SHORT}" \
      io.openshift.s2i.scripts-url="image:///usr/libexec/s2i" \
      io.s2i.scripts-url="image:///usr/libexec/s2i" \
      name="ubi9/${NAME}-${PHP_VER_SHORT}" \
      com.redhat.component="${NAME}-${PHP_VER_SHORT}-container" \
      version="1" \
      com.redhat.license_terms="https://www.redhat.com/en/about/red-hat-end-user-license-agreements#UBI" \
      help="For more information visit https://github.com/sclorg/s2i-${NAME}-container" \
      usage="s2i build https://github.com/sclorg/s2i-php-container.git --context-dir=${PHP_VERSION}/test/test-app ubi9/${NAME}-${PHP_VER_SHORT} sample-server" \
      maintainer="SoftwareCollections.org <sclorg@redhat.com>"

# Install Apache httpd and PHP
ARG INSTALL_PKGS="php83 php83-php-fpm php83-php-mysqlnd php83-php-pgsql php83-php-bcmath \
                  php83-php-gd php83-php-intl php83-php-ldap php83-php-mbstring php83-php-pdo \
                  php83-php-process php83-php-soap php83-php-opcache php83-php-xml  php83-syspaths \
                  php83-php-gmp php83-php-pecl-apcu php83-php-pecl-zip php83-php-pear php83-php-devel php83-php-sqlsrv mod_ssl hostname"

RUN dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm -y
RUN dnf install https://rpms.remirepo.net/enterprise/remi-release-9.rpm -y
    
RUN curl https://packages.microsoft.com/config/rhel/9/prod.repo > /etc/yum.repos.d/mssql-release.repo
RUN ACCEPT_EULA=Y yum install -y msodbcsql18 unixODBC unixODBC-devel
RUN ACCEPT_EULA=Y yum install -y mssql-tools


RUN dnf install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
    dnf reinstall -y tzdata && \
    rpm -V $INSTALL_PKGS && \
    dnf install php83-syspaths && \
    php -v | grep -qe "v$PHP_VERSION\." && echo "Found VERSION $PHP_VERSION" && \
    dnf -y clean all --enablerepo='*'
    

#RUN pecl install sqlsrv
#RUN pecl install pdo_sqlsrv
RUN echo "extension=pdo_sqlsrv.so" >> `php --ini | grep "Scan for additional .ini files" | sed -e "s|.*:\s*||"`/30-pdo_sqlsrv.ini
RUN echo "extension=sqlsrv.so" >> `php --ini | grep "Scan for additional .ini files" | sed -e "s|.*:\s*||"`/30-sqlsrv.ini
    

ENV PHP_CONTAINER_SCRIPTS_PATH=/usr/share/container-scripts/php/ \
    APP_DATA=${APP_ROOT}/src \
    PHP_DEFAULT_INCLUDE_PATH=/usr/share/pear \
    PHP_SYSCONF_PATH=/etc/opt/remi/php83 \
    PHP_HTTPD_CONF_FILE=php.conf \
    PHP_FPM_CONF_D_PATH=/etc/opt/remi/php83/php-fpm.d \
    PHP_FPM_CONF_FILE=www.conf \
    PHP_FPM_RUN_DIR=/run/php-fpm \
    PHP_CLEAR_ENV=ON \
    PHP_MAIN_FPM_CONF_FILE=/etc/opt/remi/php83/php-fpm.conf \
    PHP_FPM_LOG_PATH=/var/log/php-fpm \
    HTTPD_CONFIGURATION_PATH=${APP_ROOT}/etc/conf.d \
    HTTPD_MAIN_CONF_PATH=/etc/httpd/conf \
    HTTPD_MAIN_CONF_D_PATH=/etc/httpd/conf.d \
    HTTPD_MODULES_CONF_D_PATH=/etc/httpd/conf.modules.d \
    HTTPD_VAR_RUN=/var/run/httpd \
    HTTPD_DATA_PATH=/var/www \
    HTTPD_DATA_ORIG_PATH=/var/www \
    HTTPD_VAR_PATH=/var

# Copy the S2I scripts from the specific language image to $STI_SCRIPTS_PATH
COPY ./s2i/bin/ $STI_SCRIPTS_PATH

# Copy extra files to the image.
COPY ./root/ /

#RUN find / php.conf

# Reset permissions of filesystem to default values
RUN /usr/libexec/container-setup && rpm-file-permissions

# RPM uses a wrong file in the config
# Related: https://bugzilla.redhat.com/show_bug.cgi?id=2092356
RUN sed -i "s/mod_php7.c/mod_php.c/" /etc/httpd/conf.d/php83-php.conf

USER 1001

# Set the default CMD to print the usage of the language image
CMD $STI_SCRIPTS_PATH/usage
