### Installing and configuring wireguard

I configured the wireguard server manually, following the steps in the
PDF file. This only has to be done once so I didn't take the time to
write an automation script. Because you will most likely have several
clients using the VPN server it is worth using automation to set these
up. Hence the two scripts included here.

The first is **wireguard-client-install.sh**, which has to be run as
root. This script makes it unnecessary to create client private and
public key files on the server, but it is inefficent because you have to
repeatedly enter values for addresses, keys, etc. for each client system
you wish to configure, nor does it enable and start the systemd unit file
*wg-quick@wg0-client.service*.

The second is an ansible playbook: **ubuntu-wireguard-playbook.yml**,
which is the better of the two scripts. After cloning this repo to a
directory on your ansible control system, edit the [wg-clients] section
of the hosts file to specify host IP addresses and the VPN address you
want for each host. You'll also need to change the values of the
server_public_key and endpoint under [wg-clients:vars]. (The values shown
are junk) The hosts file needs to be copied to /etc/ansible/hosts, or its
contents merged with the hosts file that you probably already have in
place. If you do this be sure to edit the first line (- hosts:) of the
playbook. You'll definitely need to enter the correct 'user:' in the
playbook as well.
