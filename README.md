# Setup server for always on

# Disable Lid Sleep: Open the login configuration file:

sudo vi /etc/systemd/logind.conf

#Find the following lines, remove the # symbol in front of them, and change their values to ignore

HandleLidSwitch=lock
HandleLidSwitchExternalPower=lock
HandleLidSwitchDocked=ignore

sudo systemctl restart systemd-logind


#Disable System Inactivity Sleep: Prevent Ubuntu from suspending itself due to a lack of keyboard or mouse input:
sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target

#Turn off the screen instantly: Use the standard Linux utility vbetool:

sudo apt install vbetool -y
sudo vbetool dpms off

#(Note: Pressing any key on the laptop physical keyboard will turn it back on).Turn off the screen automatically at boot: If you run Ubuntu Server (no desktop GUI), you can configure the terminal console to blank the screen automatically after 1 minute of inactivity. Open the GRUB configuration file:

sudo vi /etc/default/grubFind 

#the line GRUB_CMDLINE_LINUX_DEFAULT and add 

consoleblank=60

#to the options. It should look like this:

GRUB_CMDLINE_LINUX_DEFAULT="quiet splash consoleblank=60"

#Save the file, exit, and update your bootloader:

sudo update-grub

Configure the CPU for Energy EfficiencyYou can force your processor to prioritize low power consumption over maximum performance. This reduces heat and fan noise.Install TLP: This is an automated background power-management tool optimized for laptops:

sudo apt install tlp tlp-rdw -y
sudo tlp start

# Set CPU Governor to Powersave: 
# Install the CPU frequency utility tools:
sudo apt install cpufrequtils -y

#Force the processor to use the energy-saving governor profile:
sudo cpufreq-set -g powersave


#If the screen stays black: If your specific laptop hardware fails to wake the video signal automatically when opened, you can map a shortcut or run 

sudo vbetool dpms on

#via an SSH terminal to force it back on.
