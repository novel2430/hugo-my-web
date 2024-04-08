---
title: 'Simple Wayfire Keybind'
date: 2024-04-08T18:03:02+08:00
draft: false
categories: 
tags: # 自由新增
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
# Some simple Wayfire custom keybind
## ScreenShot
You can use `grim` and `slurp` to have screenshot function  
- grim  
screenshot
- slurp  
select a region

Install grim and slurp
```sh
yay -S grim slurp
```
For example shell script
```sh
# ~/.config/wayfire/scripts/screenshot.sh

path="/home/novel2430/Pictures/screenshot/"   # <--- Where you want to save your screenshots
now_date=$(date '+%Y%m%d-%H%M%S')
file_name="${path}${now_date}.png"
msg="save as ${file_name}"

case $1 in
  full)
    grim ${file_name} && dunstify -a "Screenshot" "Full" "${msg}" -r 2003
    ;;
  select)
    grim -g "$(slurp)" ${file_name} && dunstify -a "Screenshot" "Select" "${msg}" -r 2003
    ;;
esac
```
## Clipboard Manager
We need two packages: `cliphist` and `wl-clipboard`  
- cliphist  
For clipboard managing
- wl-clipboard  
For copy and paste

Install both
```sh
yay -S cliphist wl-clipboard
```
```sh
# ~/.config/wayfire/scripts/clipboard.sh
cliphist list | wofi show --dmenu | cliphist decode | wl-copy
```
## Volume Control
We used `Pipewire` and `Wireplumber` to control our audio, so we can use `wpctl` to control the volume
- Increase volume
```sh
wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+
```
- Decrease volume
```sh
wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
```
- Mute
```sh
wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
```
Commands above can use with 'dunst', so we can write a simple script
```sh
# ~/.config/wayfire/scripts/volume.sh

# <this_file> up ----> Increase Volume
# <this_file> down ----> Decrease Volume
# <this_file> mute ----> Toggle Mute

sending ()
{
  volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2}')
  volume_scale=$(awk '{print $1*$2}' <<<"${volume} 100")
  dunstify -a "ChangeVolume" -r 9993 -h int:value:"$volume_scale" -i "Vol $1" "Level : ${volume_scale}%" -t 2000
}
case $1 in
  up)
    wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+ && sending $1
    ;;
  down)
    wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- && sending $1
    ;;
  mute)
    wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
    if [[ "$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $3}')" = "[MUTED]" ]]; then
      dunstify -a "ChangeVolume" -i "Muted" "MUTE" -t 2000 -r 9993
    else
      sending up
    fi
    ;;
esac
```
## Brightness Control
I prefer 'brillo'  
Install brillo
```sh
yay -S brillo
```
```sh
# ~/.config/wayfire/bright.sh
function send() {
  bright=$(printf "%.0f\n" $(brillo -G))
  dunstify -a "ChangeBrightness" -r 9993 -h int:value:"$bright" -i "Brightness $1" "Level : ${bright}%" -t 2000
}
case $1 in
  up)
	sudo brillo -u 150000 -q -A 3
	send $1
	;;
  down)
	sudo brillo -u 150000 -q -U 3
	send $1
	;;
esac
```
## Screen Lock
I prefer 'swaylock-effetcs'
```sh
yay -S swaylock-effetcs
```
```sh
# ~/.config/wayfire/scripts/swaylock.sh

swaylock \
	--screenshots \
	--clock \
	--indicator \
	--indicator-radius 100 \
	--indicator-thickness 7 \
	--effect-blur 7x5 \
	--effect-vignette 0.5:0.5 \
	--ring-color bb00cc \
	--key-hl-color 880033 \
	--line-color 00000000 \
	--inside-color 00000088 \
	--separator-color 00000000 \
	--grace 2 \
	--fade-in 0.2
```
