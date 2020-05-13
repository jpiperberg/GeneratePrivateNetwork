#!/bin/bash

# This script starts and stops internet sharing on macOS using pfctl and bootps rather than built in internet sharing


prog_name=$(basename $0)


function help {
	echo "Usage: $prog_name [-s] [-e]"
	echo
	echo "Options"
	echo "		-s, --startsharing 					start dhcp and internet sharing with preconfigured settings"
	echo "		-e, --endsharing    				end dhcp and interent sharing with preconfigured settings"
	echo "		-c <address> --connect <address> 	use openconnect to connect to vpn with specified address (modify as needed for your org)"
	echo
	echo " 		to configure setting see <url> to edit bootp.plist and pf.conf (will maybe add programatic config at some point)"
	echo "		Warning: starting dhcp internet sharing with improper configuration could have adverse effects on your network connection, proceed with caution"
	echo
}

function startsharing {
	
	echo "Enabling port forwarding"
	sudo sysctl -w net.inet.ip.forwarding=1
	echo "Enabling DHCP"
	sudo /bin/launchctl load -w /System/Library/LaunchDaemons/bootps.plist
	echo "Enabling internet sharing"
	sudo pfctl -e -f /etc/pf.conf 

}

function endsharing {
	echo "Disconnecting internet sharing"
	sudo pfctl -d
	echo "Disabling DHCP"
	sudo /bin/launchctl unload -w /System/Library/LaunchDaemons/bootps.plist
	echo "Disabling port forwarding"
	sudo sysctl -w net.inet.ip.forwarding=0
	#sudo pkill -SIGINT openconnect

	# Remove default gateway route rule when there is already a PPTP connection
	# Uncomment line below if your computer is connected to internet through a PPTP connection
#ip r | grep ppp0 && ip r | grep default | head -n1 | xargs sudo ip r del
}


function connect {
echo "Connecting to VPN"
sudo openconnect --passwd-on-stdin $1
sleep 1
echo "\n"
sleep 1
echo "\n"
echo "\n"
}


subcommand=$1
case $subcommand in
	"" | "-h" | "--help")
	help
	;;
	"-s" | "--startsharing")
	shift
	startsharing
	;;
	"-e" | "--endsharing")
	endsharing
	;;
	"-c" | "--connectVPN")
	#pass vpn server address
	connect $2
	;;
	*)
	echo "Error: '$subcommand' is not a known command." >&2
	echo "       Run '$prog_name --help' for a list of known commands." >&2
	exit 1
	;;
esac
