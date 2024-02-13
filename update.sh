#!/bin/bash
/usr/bin/hugo
sudo rm -r /http/my-web
sudo cp -r ./public /http/my-web
