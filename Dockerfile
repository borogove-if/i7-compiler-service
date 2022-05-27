FROM node:16

# Install packages
RUN apt-get update
RUN apt-get install -y \
    cron rsyslog

# Install Inform 7 compilers...

# ...6M62
ADD inform7/I7_6M62_Linux_all.tar.gz /tmp/
WORKDIR /tmp/inform7-6M62
RUN mkdir -p /usr/src/inform7/6M62
RUN ./install-inform7.sh --prefix /usr/src/inform7/6M62

# ...6G60
ADD inform7/I7_6G60_Linux_all.tar.gz /tmp/
WORKDIR /tmp/inform7-6G60
RUN mkdir -p /usr/src/inform7/6G60
RUN ./install-inform7.sh --prefix /usr/src/inform7/6G60

# ...10.1.0
WORKDIR /usr/src/inform7/v10
RUN git clone --depth=1 --branch=master https://github.com/ganelson/inweb.git
RUN bash inweb/scripts/first.sh linux

RUN git clone --depth=1 --branch=master https://github.com/ganelson/intest.git
RUN bash intest/scripts/first.sh

RUN git clone --depth=1 --branch=master https://github.com/ganelson/inform.git
WORKDIR /usr/src/inform7/v10/inform
RUN bash scripts/first.sh

# 10.1.0 Friends of Inform 7 extensions
WORKDIR /usr/src/nests/friends-of-i7
RUN git clone --depth=1 --branch=10.1 https://github.com/i7/extensions.git Extensions

# Add cron scripts
ADD cron/* /usr/src/cron/

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
COPY webservice/package.json ./

# Copy startup scripts
COPY development.sh production.sh /usr/src/

# Install npm modules
RUN yarn install
