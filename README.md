# gen2

*Dear diary, it is the second day of gentoo installation. I am writing this text while gentoo is still compiling GNOME...*

This repo contains some `gentoo` installation notes, which contradict something said in the official guide, or add more information for certain steps concerning particular configurations or issues. In general, the official guide is complete enough to follow it without major changes.

## Software

The following packages should be installed right after the base installation has completed:

```sh
sudo emerge --ask gnome neovim gnome-extra/gnome-tweaks neofetch htop sys-apps/pciutils alacritty tmux zsh dev-python/pip dev-vcs/git-lfs media-video/vlc net-p2p/transmission
```

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

Or use the following command to display timestamps in a human-readable format:

```sh
sudo tail -f /var/log/emerge.log | awk -F ':  ' '{ printf "%s:  %s\n", strftime("%d-%m-%Y %H:%M:%S", $1), $2 }'
```

Compare the following two code fragments, the first of which is printed as-is, without timestamp formatting:

```sh
1698519259:  === (1 of 56) Cleaning (acct-group/colord-0-r1::/var/db/repos/gentoo/acct-group/colord/colord-0-r1.ebuild)
1698519260:  === (1 of 56) Compiling/Merging (acct-group/colord-0-r1::/var/db/repos/gentoo/acct-group/colord/colord-0-r1.ebuild)
1698519276:  === (1 of 56) Merging (acct-group/colord-0-r1::/var/db/repos/gentoo/acct-group/colord/colord-0-r1.ebuild)
```

and the second one is displayed using formatted timestamps:

```sh
28-10-2023 21:54:19:  === (1 of 56) Cleaning (acct-group/colord-0-r1::/var/db/repos/gentoo/acct-group/colord/colord-0-r1.ebuild)
28-10-2023 21:54:20:  === (1 of 56) Compiling/Merging (acct-group/colord-0-r1::/var/db/repos/gentoo/acct-group/colord/colord-0-r1.ebuild)
28-10-2023 21:54:36:  === (1 of 56) Merging (acct-group/colord-0-r1::/var/db/repos/gentoo/acct-group/colord/colord-0-r1.ebuild)
```

## GNOME Extensions

To install `gnome tweaks`:

```sh
sudo emerge --ask gnome-extra/gnome-tweaks
```

To install chrome extensions follow [this tutorial](https://itsfoss.com/gnome-shell-extensions/).

Basically there are 4 steps in manual extension installation:

1. Download extension zip from the website: [hidetopbar@mathieu.bidon.ca](https://extensions.gnome.org/extension/545/hide-top-bar/) [dash-to-dock@micxgx.gmail.com](https://extensions.gnome.org/extension/307/dash-to-dock/)
2. Unzip the downloaded archive:

```sh
cd ~/Downloads
mkdir hide-top-bar
unzip hidetopbarmathieu.bidon.ca.v114.shell-extension.zip -d hide-top-bar
```
3. Check the extension `uuid` and rename the folder accordingly:

```sh
cat hide-top-bar/metadata.json
mv hide-top-bar hidetopbar@mathieu.bidon.ca
```

4. Move the extension folder to the system directory with other gnome extensions:

```sh
mkdir ~/.local/share/gnome-shell/extensions
mv hidetopbar@mathieu.bidon.ca ~/.local/share/gnome-shell/extensions
```

## Suspend

1. There is a problem with suspending a device, which can be avoided using the following algorithm:

```sh
# Press Ctrl+Alt+F2 - the desktop manager will become broken, but you will switch to the linux ternimal>
sudo loginctl suspend
# The laptop will suspend. Press any key to awake the laptop
# Press Ctrl+Alt+F1 - you will switch back to the 'first' linux terminal
sudo rc-service display-manager restart
```
