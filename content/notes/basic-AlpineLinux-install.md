---
title: 'Basic AlpineLinux (UEFI) Install'
date: 2024-04-05T15:12:21+08:00
draft: false
categories: 
tags: # 自由新增
    - Linux
    - AlpineLinux
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
# Alpine Linux(UEFI) Semi-Automatic Installation
## Enter Installation
Your login username is `root`, password is empty
## Check UEFI
```sh
test -d /sys/firmware/efi && echo UEFI || echo BIOS
```
## Keyboard Layout
Answer some questions
```sh
setup-keymap
## answer 'us' twice
```
## Hostname
```sh
setup-hostname <your_hostname>
```
## Networking
Alpine Linux's wiki recommend you using ethernet to connect internet  
But you can also use `setup-interfaces` to use wireless connection
Answer some questions
```sh
setup-interfaces
```
After the configuration
```sh
rc-service networking start
rc-update add networking boot
```
## Apk Repositories
You can find all repositories mirrors in [here](https://mirrors.alpinelinux.org/)  
Edit `/etc/apk/repositories`
```sh
vi /etc/apk/repositories
```
For Chinese user, you can use example below
```sh
# /etc/apk/repositories
    ...
https://mirrors.aliyun.com/alpine/latest-stable/main
https://mirrors.aliyun.com/alpine/latest-stable/community
```
Finally, update your repositories
```sh
apk update
```
## Timezone
We need to install `tzdata`
```sh
apk add tzdata
```
Set your region info
```sh
install -Dm 0644 /usr/share/zoneinfo/<Region>/<Country> /etc/zoneinfo/<Region>/<Country>
export TZ='<Region>/<Country>'
echo "export TZ='$TZ'" >> /etc/profile.d/timezone.sh
```
For Chinese user
```sh
install -Dm 0644 /usr/share/zoneinfo/Asia/Shanghai /etc/zoneinfo/Asia/Shanghai
export TZ='Asia/Shanghai'
echo "export TZ='$TZ'" >> /etc/profile.d/timezone.sh
```
## Root password
```sh
passwd
```
## SSH
Answer some questions
```sh
setup-sshd
```
## NTP
Answer some questions
```sh
setup-ntp
```
## Disk
### Useful Tools
Install some useful packages
```sh
apk add cfdisk dosfstools e2fsprogs e2fsprogs-extra
```
### Partition
> (Optional)  
> If you wish your Alpine Linux live with other Linux distributions, you can share your existing `boot` and `swap` partitions to Alpine Linux  
#### List All Disks and Partitions
```sh
fdisk -l
```
#### Change Partition Table
You can use `cfdisk` to do this step.  
```sh
cfdisk /dev/<your_disk>
```
Partition Table Example  
| mount point | partition | type | recommend size |
| --- | --- | --- | --- |
| /mnt/boot | /dev/efi_boot_partition | EFI | >=300M |
| [SWAP] | /dev/swap_partition | Linux Swap | >=512M |
| /mnt | /dev/root_partition | Linux Filesystem | space left |

Partition Table Example (With `Home` Partition)
| mount point | partition | type | recommend size |
| --- | --- | --- | --- |
| /mnt/boot | /dev/efi_boot_partition | EFI | >=300M |
| [SWAP] | /dev/swap_partition | Linux Swap | >=512M |
| /mnt | /dev/root_partition | Linux Filesystem | space left |
| /mnt/home | /dev/home_partition | Linux Filesystem | space left |
### Format
- For Boot Partition
```sh
mkfs.fat -F 32 -n ALPINEBOOT /dev/efi_boot_partition
```
- For Swap Partition
```sh
mkswap /dev/swap_partition
```
- For Root Partition
```sh
mkfs.ext4 -L ALPINEROOT /dev/root_partition
```
- For Home Partition (If you have)
```sh
mkfs.ext4 -L ALPINEHOME /dev/home_partition
```
### Mount
1. Mount Root Partition
```sh
mount /dev/root_partition /mnt
```
2. Mount Boot Partition
```sh
mkdir /mnt/boot
mount /dev/boot_partition /mnt/boot
```
3. Mount Swap Partition
```sh
swapon /dev/swap_partition
```
4. Mount Home Partition (If you have)
```sh
mkdir /mnt/home
mount /dev/home_partition /mnt/home
```
## Install Basic Package
### I only want Alpine Linux!
```sh
setup-disk -m sys /mnt
```
You can reboot your system now
### I already have other Linux distribution, and they share same grub partition
Setting `BOOTLOADER=none` in order to make the script avoiding grub installation
```sh
BOOTLOADER=none setup-disk -m sys /mnt
```
Then, you can create a `menuentry` in `/mnt/boot/grub/custom.cfg`
> You can use `blkid` to find your root partition UUID
```sh
# /mnt/boot/grub/custom.cfg
menuentry "Alpine Linux" { ## <-- You can change the name
    search --no-floppy --fs-uuid --set=root 88D1-11D6
    # You must chage Boot Partition UUID above
    linux /vmlinuz-lts root=UUID=8de6973a-4a8c-40ed-b710-c4e2b42d6b7a modules=sd-mod,usb-storage,ext4 quiet 
    # You must chage Root Partition UUID above
    initrd /initramfs-lts
}
```
