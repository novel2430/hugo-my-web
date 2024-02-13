#!/bin/bash
/usr/bin/hugo
sudo rm /http/my-web
sudo cp -r ./public /http/my-web
