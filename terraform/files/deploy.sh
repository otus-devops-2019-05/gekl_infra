#!/bin/bash
set -e

APP_DIR=${1:-$HOME}

sudo systemctl stop puma
sudo systemctl disable puma

sudo gem install bundler
git clone -b monolith https://github.com/express42/reddit.git $APP_DIR/reddit
cd $APP_DIR/reddit
bundle install

sudo mv -f ~/puma.service /etc/systemd/system/puma.service
sudo systemctl start puma
sudo systemctl enable puma
