FROM debian:jessie

LABEL maintainer="Neil Mayhew <neil.mayhew@gov.ab.ca>"
LABEL description="CKAN Application"

# Configure APT

RUN echo 'APT::Get::Assume-Yes "true";' \
         'APT::Install-Recommends "false";' >/etc//apt/apt.conf.d/00docker

RUN cat /usr/share/doc/apt/examples/sources.list
# Bring system up to date
RUN echo "deb http://us.archive.ubuntu.com/ubuntu focal main restricted" > /etc/apt/sources.list
RUN echo "deb-src http://us.archive.ubuntu.com/ubuntu focal main restricted" >> /etc/apt/sources.list
RUN echo "deb http://security.ubuntu.com/ubuntu focal-security main restricted" >> /etc/apt/sources.list
RUN echo  "deb-src http://security.ubuntu.com/ubuntu focal-security main restricted" >> /etc/apt/sources.list
RUN echo  "deb http://us.archive.ubuntu.com/ubuntu focal-updates main restricted" >> /etc/apt/sources.list
RUN echo  "deb-src http://us.archive.ubuntu.com/ubuntu focal-updates main restricted" >> /etc/apt/sources.list

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 0E98404D386FA1D9
RUN export DEBIAN_FRONTEND=noninteractive \
 && apt-get -q update --force-yes\
 && apt-get -q dist-upgrade --force-yes

RUN add-apt-repository restricted
RUN add-apt-repository multiverse
RUN add-apt-repository universe
# Install Apache and WSGI

RUN export DEBIAN_FRONTEND=noninteractive \
 && apt-get -q install apt-utils \
        apache2 \
        libapache2-mod-wsgi --force-yes

RUN apt-get install curl && apt-get install vim \
 && apt-get install less

RUN apt-get install openssh-server


# Configure Apache:

ENV CKAN_SERVER_NAME localhost

COPY apache/ckan.conf       /etc/apache2/sites-enabled/
COPY apache/datapusher.conf /etc/apache2/sites-enabled/

# Install packages required for virtualenv and pip

RUN export DEBIAN_FRONTEND=noninteractive \
 && apt-get -q install \
        virtualenv \
        git \
        python-dev \
        gcc
        # python-pip \

# Install CKAN

ENV CKAN_HOME         /usr/lib/ckan/default
ENV CKAN_SITE_URL     http://$CKAN_SERVER_NAME:8081
ENV CKAN_CONFIG       /etc/ckan/default
ENV DATAPUSHER_CONFIG /etc/ckan/datapusher
ENV CKAN_STORAGE_PATH /var/lib/ckan

# Set up a virtual environment for CKAN
RUN mkdir -p $CKAN_HOME
RUN virtualenv $CKAN_HOME
RUN ln -s $CKAN_HOME/bin/pip /usr/local/bin/ckan-pip
RUN ln -s $CKAN_HOME/bin/paster /usr/local/bin/ckan-paster

# Install CKAN packages and their requirements
RUN export DEBIAN_FRONTEND=noninteractive \
 && apt-get -q install \
        libpq-dev \
        libldap2-dev \
        libsasl2-dev \
        libssl-dev \
        libxml2-dev \
        libxslt-dev
RUN ckan-pip install pbr
COPY packages.txt /tmp/
RUN set -e; \
    cat /tmp/packages.txt | while read URL REQUIREMENTS; do \
        echo "\\n**** Installing $URL ****\\n"; \
        ckan-pip install -e $URL; \
        if [ -n "$REQUIREMENTS" ]; then \
            echo "\\n**** Installing $CKAN_HOME/src/$REQUIREMENTS ****\\n"; \
            ckan-pip install -r $CKAN_HOME/src/$REQUIREMENTS; \
        fi; \
    done; \
    rm -f /tmp/packages.txt
COPY packages2.txt /tmp/
RUN set -e; \
    cat /tmp/packages2.txt | while read URL REQUIREMENTS; do \
        echo "\\n**** Installing $URL ****\\n"; \
        ckan-pip install -e $URL; \
        if [ -n "$REQUIREMENTS" ]; then \
            echo "\\n**** Installing $CKAN_HOME/src/$REQUIREMENTS ****\\n"; \
            ckan-pip install -r $CKAN_HOME/src/$REQUIREMENTS; \
        fi; \
    done; \
    rm -f /tmp/packages2.txt
COPY packages3.txt /tmp/
RUN set -e; \
    cat /tmp/packages3.txt | while read URL REQUIREMENTS; do \
        echo "\\n**** Installing $URL ****\\n"; \
        ckan-pip install -e $URL; \
        if [ -n "$REQUIREMENTS" ]; then \
            echo "\\n**** Installing $CKAN_HOME/src/$REQUIREMENTS ****\\n"; \
            ckan-pip install -r $CKAN_HOME/src/$REQUIREMENTS; \
        fi; \
    done; \
    rm -f /tmp/packages3.txt

# TMP-BUGFIX https://github.com/ckan/ckan/issues/3388
RUN ckan-pip install "polib==1.0.7"

# Config directories
RUN mkdir -p $CKAN_CONFIG
RUN ln -s $CKAN_HOME/src/ckan/ckan/config/who.ini $CKAN_CONFIG/
COPY ckan-settings.ini $CKAN_HOME/
COPY apache/ckan.wsgi $CKAN_CONFIG/
COPY datapusher_settings.py $DATAPUSHER_CONFIG/
COPY apache/datapusher.wsgi $DATAPUSHER_CONFIG/

# Housekeeping

COPY ./ckan-entrypoint.sh /
ENTRYPOINT ["/ckan-entrypoint.sh"]

VOLUME ["/var/lib/ckan"]

# ckan datapusher
EXPOSE 8001 8800 5000

RUN  . /usr/lib/ckan/default/bin/activate

COPY .bash_profile /

RUN cp  /usr/lib/ckan/default/src/ckan/ckan/public/base/css/main.css /usr/lib/ckan/default/src/ckan/ckan/public/base/css/main.debug.css

#RUN ["/usr/lib/ckan/default/bin/paster", "--plugin=ckan", "search-index",  "rebuild",  "--config=/etc/ckan/default/ckan.ini"]

#CMD ["apachectl", "-DFOREGROUND"]
CMD  ["/usr/lib/ckan/default/bin/paster", "serve", "--reload", "/etc/ckan/default/ckan.ini"]
