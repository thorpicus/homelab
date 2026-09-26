nordvpn disconnect
sudo apt-get purge nordvpn
sudo apt-get autoremove
rm -rf ~/.config/nordvpn
rm -rf /var/lib/nordvpn
sudo reboot
