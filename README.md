### Installing and configuring wireguard

I configured the wireguard server manually, following the steps in the
PDF file. This only has to be done once so it's not worth the time to
write an automation script. Because you will most likely have several
clients using the VPN server it is worth using automation to set these
up. Hence the two scripts included here.

The first is **wireguard-client-install.sh**, which has to be run as
root. This script makes it unnecessary to create client private and
public key files on the server, but it is inefficent because you have to
repeatedly enter values for addresses, keys, etc. for each client system
you wish to configure, nor does it enable and start the
*wg-quick@wg0-client.service*.

The second is an ansible playbook: **ubuntu-wireguard-playbook.yml**,
which is the better of the two scripts. Before you run this, however, you
need to edit the [lxc-containers] section of the hosts file. You'll also
need to change the values of the server_public_key and endpoint under
[lxc-containers:vars]. And the hosts file needs to be copied to
/etc/ansible/hosts, or its contents merged with the hosts file that is
already there. Also, the templates directory should be copied to the
directory you use for your ansible stuff and the playbook has to be
edited in the 'template:' section so as to specify the correct 'src:' for
the wg0-client.conf template file. You will probably want to change the
names of the sections from [lxc-containers] to something more
appropriate. If you do this be sure to edit the first line (- hosts:) of
the playbook. You'll need to enter the correct 'user:' in the playbook.
