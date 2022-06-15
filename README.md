# GeneratePrivateNetwork
Start and share a user specified connection from one mac to another computer.

## Author
Jamie Piperberg

## License
GNU GPLv3

## Getting Started

See Wiki 

## Usage

To start port forwarding and DHCP based on preconfigured /etc/bootpd.plist and /etc/pf.conf files

```sh
toggleSharing.bash -s
```

To stop sharing and DHCP:

```sh
toggleSharing.bash -e 
```


## Installing

Place script in your preferred location and add an alias in your shell profile if you wish.

This assumes you have configured your bootpd.plist and pf.conf files (samples provided) and installed and connected any necessary connections (like VPN)

