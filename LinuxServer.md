
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


You can use cron if your version has the @reboot feature. From man 5 crontab:

Instead of the first five fields, one of eight special strings may appear:

  string         meaning
  ------         -------
  @reboot        Run once, at startup.
  …
You can edit a user-local crontab with the command crontab -e without root privileges. Then add the following line:

@reboot /usr/local/bin/some-command
Now your command will be run once at boot time.
https://unix.stackexchange.com/questions/85666/how-to-autostart-a-background-program-by-a-non-root-user

crontab

static wifi settings

# interfaces(5) file used by ifup(8) and ifdown(8)
auto lo
iface lo inet loopback

auto wlp3s0
iface wlp3s0 inet static
	address 192.168.100.200
	netmask 255.255.255.0
	gateway 192.168.100.1
	dns-nameservers 8.8.8.8 8.8.4.4
	wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf

network={
	ssid="Elisa"
	psk=-------------------------------------------------------------------
}

use wpa_passphrase command to generate hashed password key
