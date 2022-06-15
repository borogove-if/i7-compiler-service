#! /bin/bash

# Fix rsyslog logging
sed -i '/imklog/s/^/#/' /etc/rsyslog.conf
sed -i 's/^#cron/cron/' /etc/rsyslog.conf

# Install cron scripts
cat /usr/src/cron/*.cron | crontab -

# cron won't run without rsyslog? And rsyslog won't start when placed in Dockerfile
rsyslogd
cron

# Build web service
cd /usr/src/app
yarn build

# Start web service
cd /usr/src/app/dist
node index.js
