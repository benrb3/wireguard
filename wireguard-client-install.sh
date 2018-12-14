#!/bin/bash

# gather information
clear
echo ""
echo -n "Enter the client IP address and press [Enter]:"
  read client_ip_address
echo -n "Enter the server IP address and press [Enter]:"
  read server_ip_address
echo -n "Enter the server port and press [Enter]:"
  read server_port
echo -n "Enter the server's public key and press [Enter]:"
  read server_public_key
config_dir="/etc/wireguard"

# get confirmation of configuration
echo ""
echo "Here is the information you have entered:"
echo "  client_ip_address = $client_ip_address"
echo "  server_ip_address = $server_ip_address"
echo "  server_port = $server_port"
echo "  server_public_key = $server_public_key"
echo ""
echo -n "Is this information correct [y/n]:"
read response

if [ $response = "y" ]; then

    # install wireguard software
    add-apt-repository -y ppa:wireguard/wireguard
    apt-get -y update
    apt-get -y install wireguard-dkms wireguard-tools

    # check if linux-headers file is installed
    header_file=$(dpkg --get-selections | grep linux-headers-$(uname -r) 2>&1)

    result=$(echo $header_file | grep install | awk '{print $2}')
    if [ ! $result ]; then
        echo "File not installed"
        apt-get -y install linux-headers-$(uname -r)
    fi

    # generate client keys
    client_private_key=$(wg genkey)
    client_public_key=$(echo $client_private_key | wg pubkey)

# write configuration file (here document can't be indented)
cat << EOF >> $config_dir/wg0-client.conf
[Interface]
Address = $client_ip_address
PrivateKey = $client_private_key

[Peer]
PublicKey = $server_public_key
Endpoint = $server_ip_address:$server_port
AllowedIPs = 0.0.0.0/0
PersistentKeepalive = 21
EOF

    echo ""
    echo "SUCCESS!"
    echo ""

    echo "The client configuration has been written to: $config_dir/wg0-client.conf"
    echo ""; echo ""
    echo "Register this client system with the wireguard server using this command:"
    echo ""
    echo "  sudo wg set wg0 peer $client_public_key allowed-ips $client_ip_address"
    echo ""

else
    exit
fi
