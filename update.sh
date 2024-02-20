#!/bin/bash
rm -rf /home/novel2430/hugo-my-web/public
/usr/bin/hugo
sudo rm -rf /http/my-web
sudo cp -r ./public /http/my-web
