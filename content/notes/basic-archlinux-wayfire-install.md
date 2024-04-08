---
title: 'Basic Archlinux Wayfire Install'
date: 2024-03-26T21:40:18+08:00
draft: false
categories: 
tags: # 自由新增
    - Linux
    - Archlinux
    - Wayfire
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
# Basic ArchLinux(UEFI) + WayFire Install
## Basic Arch Install
### [ Check UEFI or BIOS ]
```sh
ls /sys/firmware/efi/efivars
```
If the directory not exist, you are not in UEFI mode.
### [ Internet ]
#### Check system activate internet interface  
```sh
ip link
```
#### For Ethernet (DHCP)  
Good to go!
#### For WiFi (iwd)  
enter interactive prompt  
```sh
iwctl
```
list all wifi device
```sh
[iwd] device list
```
select the device you want to use, i.e: wlan0  
and start scanning
```sh
[iwd] station <device> scan
```
after scanning, you can list all available networks
```sh
[iwd] station <device> get-networks
```
connect one network
```sh
[iwd] station <device> connect <network-name>
```
leave iwclt
```sh
[iwd] exit
```
#### Ping test
```sh
ping archlinux.org
```
### [ Update System Time ]
```sh
timedatectl set-ntp true
```
### [ Partition ]
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
#### Format Partitions
- For Boot Partition
```sh
mkfs.fat -F 32 -n ARCHBOOT /dev/efi_boot_partition
```
- For Swap Partition
```sh
mkswap /dev/swap_partition
```
- For Root Partition
```sh
mkfs.ext4 -L ARCHROOT /dev/root_partition
```
- For Home Partition (If you have)
```sh
mkfs.ext4 -L ARCHHOME /dev/home_partition
```
#### Mount Partitions
1. Mount Root Partition
```sh
mount /dev/disk/by-label/ARCHROOT /mnt
```
2. Mount Boot Partition
```sh
mkdir /mnt/boot
mount /dev/disk/by-label/ARCHBOOT /mnt/boot
```
3. Mount Swap Partition
```sh
swapon /dev/swap_partition
```
4. Mount Home Partition (If you have)
```sh
mkdir /mnt/home
mount /dev/disk/by-label/ARCHHOME /mnt/home
```
### [ Install Basic Package ]
#### (Optional) Setup Mirrorlist
edit `/etc/pacman.d/mirrorlist` file  
Example For Chinese User:
```sh
# /etc/pacman.d/mirrorlist
Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/$repo/os/$arch
```
#### Install Packages
```sh
pacstrap /mnt base linux linux-firmware networkmanager vim man-db man-pages texinfo
```
- base, linux, linux-firmware  
must install

- networkmanager  
for internet

- vim  
text editor, or you can choose `nano`

- man-db, man-pages, texinfo  
For man page
### [ Generate Fstab ]
```sh
genfstab -U /mnt >> /mnt/etc/fstab
```
### [ Chroot to System ]
```sh
arch-chroot /mnt
```
### [ Timezone ]
```sh
ln -sf /usr/share/zoneinfo/<Your_Region>/<Your_City> /etc/localtime
```
Example For Chinese User:
```sh
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
```
run `hwclock` to generate `/etc/adjtime`
```sh
hwclock --systohc
```
### [ Locale ]
1. edit the file `/etc/locale.gen`, uncomment `en_US.UTF-8 UTF-8`
2. run `locale-gen` to generate locale info
```sh
locale-gen
```
3. build `/etc/locale.conf` file, set the variable `LANG`
```sh
# /etc/locale.conf
LANG=en_US.UTF-8
```
### [ Host Name ]
build `/etc/hostname` file
```sh
# /etc/hostname
<your_host_name>
```
### [ Set Root User Password ]
```sh
passwd
```
### [ Enable NetworkManager Service ]
```sh
systemctl enable NetworkManager.service 
```
We are now in chroot, so we do not need to start `NetworkManager` service. After bootloader installed and reboot to system, the `NetworkManager` will start automatically.
### [ Install Microcode ]
- For AMD User
```sh
pacman -S amd-ucode
```
- For Intel User
```sh
pacman -S intel-ucode
```
### [ Install Grub ]
```sh
pacman -S grub efibootmgr
```
#### (Optional) os-prober -- For Dual Boot
```sh
pacman -S os-prober
```
If you want dual boot with `Windows OS`, you may need `ntfs-3g`
```sh
pacman -S ntfs-3g
```
### [ Messing with GRUB :( ]
#### I only need LINUX! (No Dual Boot)
1. install grub on your boot partition
```sh
# command below is for x86_64 user
# you can find more info in https://wiki.archlinux.org/title/GRUB
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
```
2. generate `/boot/grub/grub.cfg`
```sh
grub-mkconfig -o /boot/grub/grub.cfg
```
#### I cannot leave windows... (Dual Boot)
NOTE: Setup Dual Booting always has many problems, the following guidance is only for reference.
1. install grub on your boot partition
```sh
# command below is for x86_64 user
# you can find more info in https://wiki.archlinux.org/title/GRUB
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
```
2. edit `/etc/default/grub`  
```sh
# /etc/default/grub
    ...
# Probing for other operating systems is disabled for security reasons. Read
# documentation on GRUB_DISABLE_OS_PROBER, if still want to enable this
# functionality install os-prober and uncomment to detect and include other
# operating systems.
GRUB_DISABLE_OS_PROBER=false # <-- Uncomment this Line
```
3. generate `/boot/grub/grub.cfg`  
```sh
grub-mkconfig -o /boot/grub/grub.cfg
# You must make sure os-prober find your windowsOS boot partition
```
### [ Reboot ]
1. leave chroot
```sh
exit
```
2. umount /mnt
```sh
umount -R /mnt
```
3. swapoff
```sh
swapoff /dev/swap_partition
```
4. shutdown
```sh
shutdown now
```
5. reboot your computer  
(Make sure you unplugged your Arch Linux Installer USB drive)  
If everything go well, you will see GRUB menu after booting.
## Setup Basic Destop Environment
### [ Root Login ]
We only have user `root` right now, use root account to log in
### [ Check Internet ]
Normally, `NetworkManager.service` will start automatically, you can use `ping` to check your internet connection
```sh
# ping example
ping archlinux.org
```
You can use `nmtui` to configure your connection
### [ Neofetch ] <-- VERY IMPORTANT!!!
```sh
pacman -S neofetch
neofetch
```
If you don't hava `neofetch`, you are not using Arch :)
### [ GPU Card ]
**If you are not using NVIDIA card, GOOOOOOD!!**  
**I'm not familiar with AMD gpu...Please read wiki!**
#### only Nvidia
```sh
pacman -S mesa-utils nvidia nvidia-utils
```
(Optional) You may need `nvtop` to be coooool(?)
```sh
pacman -S nvtop
```
After the installation, you need to reboot you computer
#### only AMD
Please read the wiki (AMD GPU) first :)  
[link](https://wiki.archlinux.org/title/AMDGPU)
```sh
pacman -S mesa mesa-utils
```
For Vulkan support
```sh
pacman -S vulkan-radeon
```
#### Intel+NVIDIA
Please read the wiki (INTEL GPU) first :)  
[link](https://wiki.archlinux.org/title/intel_graphics)  
For our Intel card (with Vulkan)
```sh
pacman -S mesa mesa-utils vulkan-intel
```
For our Nvidia card :(
```sh
pacman -S mesa-utils nvidia nvidia-utils nvidia-prime
```
(Optional) You may need `nvtop` to be coooool(?)
```sh
pacman -S nvtop
```
You can use `prime-run <command>` to run stuff on Nvidia card  
After the installation, you need to reboot you computer
### [ Audio ]
#### Install Some Basic Packages
```sh
pacman -S alsa-utils alsa-firmware sof-firmware alsa-ucm-conf
```
#### Pipewire and Wireplumber
```sh
pacman -S pipewire wireplumber pipewire-pulse
```
### [ Sudo ]
#### Install Sudo
```sh
pacman -S sudo
```
#### Create one normal user
```sh
useradd -m -G wheel -s /bin/bash <new_user_name>
```
set this user's password
```sh
passwd <new_user_name>
```
#### Edit sudo file
edit file
```sh
EDITOR=vim visudo
```
uncomment one line in sudo file
```sh
# In visudo
    ...
###
### User privilege specification
###
root ALL=(ALL:ALL) ALL
## Uncomment to allow members of group wheel to execute any command
%wheel ALL=(ALL:ALL) ALL # <-- uncomment this line
    ...
```
#### Log out user `root`
After installed Sudo, now we can use new user account to do stuff
```sh
exit
```
### (For Chinese User) [ Clash ]
We need a good way to Love GFW ...
```sh
sudo pacman -S curl clash
```
You can use `curl` to get your `config.yaml`
```sh
cd <your_clash_directory>
curl https://gitee.com/mirrors/Pingtunnel/raw/master/GeoLite2-Country.mmdb > ./Country.mmdb
curl <your_sub_url> > ./config.yaml
```
Edit clash systemd unit
```sh
sudo vim /etc/systemd/user/clash.service
```
```sh
# /etc/systemd/user/clash.service
[Unit]
Description=Clash, Good Way to Love GFW
After=network.target

[Service]
Type=simple
Restart=on-abort
ExecStart=/usr/bin/clash -d <your_clash_directory>

[Install]
WantedBy=multi-user.target
```
Reload Daemon
```sh
systemctl --user daemon-reload
```
Start Clash Service
```sh
systemctl --user start clash.service
```
Check Clash Service
```sh
systemctl --user status clash.service
```
Set Clash as your current system porxy
```sh
export http_proxy=http://127.0.0.1:7890
export https_proxy=http://127.0.0.1:7890
```
### [ YAY (AUR Helper) ]
[link](https://github.com/Jguer/yay)
```sh
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```
After installed `yay`, we can use `yay -S 'package'` instead of `sudo pacman -S 'package'`
### (For Chinese User) [ Chinese Fonts ]
```sh
yay -S wqy-zenhei
```
### [ Wayfire ]
#### install wayland packages
```sh
yay -S wayland wayland-protocals xorg-xwayland
```
#### install wayfire
```sh
yay -S wayfire
```
#### install basic font (For terminal emulator)
```sh
yay -S ttf-dejavu 
```
#### install terminal emulator
There are many terminal emulators on arch, such as `Alacritty`, `Kitty`, `Foot` ...
```sh
# I prefer foot
yay -S foot
```
#### download default config file
```sh
curl https://raw.githubusercontent.com/WayfireWM/wayfire/master/wayfire.ini > ~/.config/wayfire.ini
```
#### set default terminal emulator
edit ~/.config/wayfire.ini
```sh
# ~/.config/wayfire.ini
    ...
# Applications ─────────────────────────────────────────────────────────────────

[command]

# Start a terminal
# https://github.com/alacritty/alacritty
binding_terminal = <super> KEY_ENTER
command_terminal = alacritty # <-- Change Here
    ...
```
#### Run Wayfire
```sh
wayfire
```
If you use QEMU to run wayfire
```sh
WLR_RENDERER_ALLOW_SOFTWARE=1 wayfire
```
