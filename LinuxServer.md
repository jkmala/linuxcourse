
autologin
https://askubuntu.com/questions/51086/how-do-i-enable-auto-login-in-lightdm

For Ubuntu 14.04 create the file:

/etc/lightdm/lightdm.conf.d/12-autologin.conf
and add:

[SeatDefaults]
autologin-user=youruser
autologin-user-timeout=0

not for sudousers!

localization
https://www.thomas-krenn.com/en/wiki/Configure_Locales_in_Ubuntu
$ locale
$ locale -a
$ cat /etc/default/locale 

update-locale LANG=fi_FI.UTF-8

run script at startup for non-sudo-user
https://linuxconfig.org/how-to-automatically-execute-shell-script-at-startup-boot-on-systemd-linux


crontab

static wifi settings

