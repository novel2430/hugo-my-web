---
title: 'Basic Wayfire Applications'
date: 2024-03-26T21:53:17+08:00
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
# Applications on Wayfire
## Setup Wayfire Basic Environment
### [ App Menu ] (wofi)
```sh
yay -S wofi
```
```sh
# ~/.config/wayfire.ini
    ...
# Start your launcher
# https://hg.sr.ht/~scoopta/wofi
# Note: Add mode=run or mode=drun to ~/.config/wofi/config.
# You can also specify the mode with --show option.
binding_launcher = <super> KEY_D # <-- Change key binding
command_launcher = wofi --show drun # <-- Change exec command
    ...
```
### [ Web Browser ] (firefox)
```sh
yay -S firefox
```
Now you can use `Wofi` to open `Firefox`
### [ Notification ] (dunst)
```sh
yay -S dunst libnotify
```
Dunst's config file => `~/.config/dunst/dunstrc`
```sh
mkdir ~/.config/dunst
cp /etc/dunst/dunstrc ~/.config/dunst/dunstrc
```
Change notification app to dunst
```sh
# ~/.config/wayfire.ini
    ...
# Notifications
# https://wayland.emersion.fr/mako/
notifications = mako # <-- change to dunst
    ...
```
After restarting Wayfire, you can try sending notification
```sh
dunstify "hello!"
```
### [ Autostart Script ]
You can store your script anywhere, but I prefer store it in `~/.config/wayfire/autostart.sh`
```sh
mkdir ~/.config/wayfire
touch ~/.config/wayfire/autostart.sh
chmod +x ~/.config/wayfire/autostart.sh
```
You need to specify script in `~/.config/wayfire.ini`
```sh
# ~/.config/wayfire.ini
    ...
# Startup commands ─────────────────────────────────────────────────────────────

[autostart]

# Automatically start background and panel.
# Set to false if you want to override the default clients.
autostart_wf_shell = true # <-- You can set false
my_autostart = ~/.config/wayfire/autostart.sh # <-- Add this line
    ...
```
### [ Wallpaper ] (swaybg)
```sh
yay -S swaybg
```
Our wallpaper should execute during Wayfire starting process, so we need to execute `swaybg` command in our autostart script.
```sh
# ~/.config/wayfire/autostart.sh

### Wallpaper
swaybg -i <your_wallpaper> &
```
### [ XDG-DESKTOP-PORTAL and Audio]
```sh
yay -S xdg-desktop-portal xdg-desktop-portal-wlr xdg-desktop-portal-gtk
```
The main reason setting up `xdg-desktop-portal` is to using desktop recorder such as `Obs Studio`  
So, we need to start `xdg-desktop-portal` service and audio service in autostart script.
```sh
# ~/.config/wayfire/autostart.sh
    ...
### XDG-DESKTOP-PORTAL
dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
systemctl --user stop pipewire pipewire-pulse wireplumber xdg-desktop-portal xdg-desktop-portal-wlr xdg-desktop-portal-gtk
systemctl --user start pipewire pipewire-pulse wireplumber xdg-desktop-portal xdg-desktop-portal-wlr xdg-desktop-portal-gtk
```
For `xdg-desktop-portal` service, you can install `obs-studio` and try desktop recording  
For audio service, you can run `wpctl status` and check the ouput.
```sh
# Ouput of 'wpctl status'
    ...
Audio
  |- Devices:
  | ...
  |- Sinks:
  |      * <something_here> ... [vol: 1.00]
    ...
```
### [ Bar ] (waybar)
```sh
yay -S waybar
```
You may need some special fonts to show icon.
```sh
# Nerd Fonts - Ubuntu
yay -S ttf-ubuntu-nerd
```
You can copy two default config files in any place you want
```sh
cp /etc/xdg/waybar/config.jsonc ~/.config/wayfire/waybar-config.jsonc
cp /etc/xdg/waybar/style.css ~/.config/wayfire/waybar-style.css
```
Put waybar command in autostart script
```sh
# ~/.config/wayfire/autostart.sh
    ...
### Waybar
waybar -c <your_waybar_config> -s <your_waybar_style> &
```
### [ Network Applet ] (network-manager-applet)
`network-manager-applet` is a small tool to configure your network connection in GUI
```sh
yay -S network-manager-applet
```
Add command in your autostart script
```sh
# ~/.config/wayfire/autostart.sh
    ...
### NetworkManager Applet
nm-applet &
```
### [ Audio Control ] (pavucontrol)
`pavucontrol` is a small tool to configure your audio optput device in GUI
```sh
yay -S pavucontrol
```
### [ Bluetooth ] (bluez bluez-obex blueman)
```sh
yay -S bluez bluez-obex blueman
```
Enable bluez service
```sh
systemctl enable bluetooth.service
systemctl start bluetooth.service
```
Edit your autostart script
```sh
# ~/.config/wayfire/autostart.sh
    ...
### Bluetooth
systemctl --user restart dbus-org.bluez.obex.service
systemctl --user restart blueman-applet.service
```
Edit your Dunst's config file (For bluetooth message actions)
```sh
# ~/.config/dunst/dunstrc
    ...
    ### Misc/Advanced ###

    # dmenu path.
    dmenu = /usr/bin/wofi -dmenu # <-- Change here to wofi
    ...
```
By default, mouse middle click event triggers notify action
```sh
# ~/.config/dunst/dunstrc
    ...
    ### mouse

    # Defines list of actions for each mouse event
    # Possible values are:
    # * none: Don't do anything.
    # * do_action: Invoke the action determined by the action_name rule. If there is no
    #              such action, open the context menu.
    # * open_url: If the notification has exactly one url, open it. If there are multiple
    #             ones, open the context menu.
    # * close_current: Close current notification.
    # * close_all: Close all notifications.
    # * context: Open context menu for the notification.
    # * context_all: Open context menu for all notifications.
    # These values can be strung together for each mouse event, and
    # will be executed in sequence.
    mouse_left_click = close_current
    mouse_middle_click = do_action, close_current # <-- Here
    mouse_right_click = close_all
    ...
```
### (For Chinese User) [ Fcitx5 ]
You may want read wiki [link](https://wiki.archlinuxcn.org/wiki/Fcitx5)
```sh
# For Pinyin
yay -S fcitx5 fcitx5-qt fcitx5-gtk fcitx5-chinese-addons fcitx5-configtool
```
```sh
# For Chewing
yay -S fcitx5 fcitx5-qt fcitx5-gtk fcitx5-chinese-addons fcitx5-configtool fcitx5-chewing
```
You can edit your `~/.bashrc` (For Bash User) or `~/.zshrc` (For Zsh User) to add fcitx5 environment variables  
```sh
# ~/.bashrc
    ...
export GTK_IM_MODULE="fcitx"
export QT_IM_MODULE="fcitx"
export XMODIFIERS="@im=fcitx"
export SDL_IM_MODULE="fcitx"
export INPUT_METHOD="fcitx"
```
Do not forget `source ~/.bashrc` or `source ~/.zshrc`  
Edit your wayfire config to enable input method plugin
```sh
# ~/.config/wayfire.ini
    ...
# List of plugins to be enabled.
# See the Configuration document for a complete list.
plugins = \
  alpha \
  animate \
  autostart \
  command \
  cube \
  decoration \
  expo \
  fast-switcher \
  fisheye \
  foreign-toplevel \
  grid \
  gtk-shell \
  idle \
  invert \
  move \
  oswitch \
  place \
  resize \
  switcher \
  vswitch \
  wayfire-shell \
  window-rules \
  wm-actions \
  wobbly \
  wrot \
  zoom \
  input-method-v1  # <-- add this line
```
Finally, add Fcitx5 in your autostart script
```sh
# ~/.config/wayfire/autostart.sh
    ...
### Fcitx5
fcitx5 --replace -d &
```
