---
title: 'Alpine to Sway'
date: 2024-04-07T20:03:09+08:00
draft: false
categories: 
tags: # 自由新增
    - Linux
    - AlpineLinux
    - Sway
isCJKLanguage: true # 是否是中文(chinese,japanese,korea) 字數判斷用
comments: true
showToc: true # 顯示目錄
TocOpen: true # 預設打開目錄
hidemeta: false # 是否隱藏meta訊息(ex:發布日期、作者...etc)
disableShare: false # 取消社群分享區塊
showbreadcrumbs: true # 於頂部顯示文章路徑
ShowWordCounts: true
ShowReadingTime: true
ShowLastMod: true
---
# Alpine Linux with Sway
## Bash, Text Editor
### Packages
```sh
apk add vim bash
```
## Create Non Root User
### Packages
```sh
apk add sudo shadow
```
### Command
#### Add User
```sh
useradd -m -G wheel -s /bin/bash <user_name>
passwd <user_name>
```
#### sudo file
```sh
EDITOR=vim visudo
# Make wheel group can use sudo
```
## Setup eudev
```sh
setup-devd udev
```
## GPU
- Intel
```sh
apk add mesa-dri-gallium
```
- AMD  
Read [here](https://wiki.alpinelinux.org/wiki/Radeon_Video)
- Nvidia  
Read [here](https://wiki.alpinelinux.org/wiki/NVIDIA)
## PAM
```sh
apk add linux-pam shadow-login
```
## Elogind
```sh
apk add elogind polkit-elogind dbus
rc-update add elogind
rc-update add polkit
rc-update add dbus
```
## Sway
```sh
apk add sway
```
## Reboot
After rebooting your computer, you should use your non-root userer to log in
## Run Sway
You can test `loginctl` output first, the output should not contains any `No session`  
After testing, you can run Sway
```sh
dbus-run-session -- sway
```
