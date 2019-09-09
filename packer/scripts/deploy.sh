#!/bin/bash
cd /usr/
git clone -b monolith https://github.com/express42/reddit.git
cd reddit
bundle install
cp ~/puma.service /lib/systemd/system/puma.service
systemctl daemon-reload
systemctl enable puma
systemctl start puma
