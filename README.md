# gen2

*Dear diary, it is the second day of gentoo installation. I am writing this text while gentoo is still compiling GNOME...*

This repo contains some `gentoo` installation notes, which contradict something said in the official guide, or add more information for certain steps concerning particular configurations or issues. In general, the official guide is complete enough to follow it without major changes.

## Wireless network

With wired network the connection should be established out-of-the-box, but wireless network configuration is more intricate, especially if you have an `ssid` with special characters like emojis which are quite challenging to type from keyboard.

0. Make sure that the target interface is `up`:

```sh
sudo ip link set wlp2s0 up
```

To persist the changes (for starting the interface on boot automatically) make sure that appropriate link exists:

```sh
cd /etc/init.d

sudo ln -s net.lo net.wlp2s0
sudo rc-update add net-wlp2s0 default
```

1. Seemingly the following packages are enough to support wireless network connectivity:

```sh
sudo emerge --ask net-misc/dhcpcd net-misc/netifrc net-wireless/iw net-wireless/wpa_supplicant
```

2. After that you will need to create `/etc/wpa_supplicant/wpa_supplicant.conf` **manually** with the following content:

```sh
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=wheel
update_config=1
network={
  ssid="🤍💙🤍"
  psk="password"
}
```

3. Then you can start the `wpa_supplicant` service:

```sh
sudo rc-service wpa_supplicant start
```

Which should say that the service started successfully. After any change in the `/etc/wpa_supplicant/wpa_supplicant.conf` the service must be restarted:

```sh
sudo rc-service wpa_supplicant restart
```

4. If your `ssid` contains non-printable characters (emojis, etc), the following strategy is advised:

4.1 List available networks and save them to a local file:

```sh
sudo iw wlp2s0 scan > nets.txt
```

4.2 Open the file `nets.txt` and find the `ssid` which is most likely yours. For example, mine looks like `\xf0\x9f\xa4\x8d\xf0\x9f\x92\x99\xf0\x9f\xa4\x8d`.

4.3 Copy this `ssid` somewhere where it can be viewed more easily. Your task now is to somehow `echo` this string with `-e` flag:

```sh
echo -e '\xf0\x9f\xa4\x8d\xf0\x9f\x92\x99\xf0\x9f\xa4\x8d' > ssid.txt
```

4.4 Open `/etc/wpa_supplicant/wpa_supplicant.conf` and copy `ssid` from file `ssid.txt`, then restart `wpa_supplicant` using the command above

4.5 Check the connection status:

```sh
iw wlp2s0 link
```

If everything went fine, the command aove displays the information about the wireless network you've just connect to

## Packages

There are some notes about package installation

### Desktop environment

**Choose desktop profile as early as possible** if you are planning to install a desktop manager. It will save time later on building and installing dependencies. **Start installing GNOME only in the evening**, since it will be running for the whole night and beyond.

### Text editor

After booting **install nvim text editor as early as possible**, since by default only nano editor is available which is not quite convenient to use.

## Fstab

Despite the official guide it is laborious to creage `fstab` manually. Instead `genfstab` can be used if you are installing from `archiso`:

```sh
genfstab /mnt >> /mnt/etc/fstab
```

## Check installation status

The following command can be used to get information about currently installing packages:

```sh
sudo tail -f /var/log/emerge.log
```
