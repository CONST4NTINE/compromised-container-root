#!/bin/sh

initialise_SSH() {
	useradd -rm -d /home/ubuntu -s /bin/bash -g root -G sudo -u 1000 tester
	PASSWORD=$(openssl rand -base64 32)
	mkdir -p /var/run/sshd
	echo  "tester:$PASSWORD" | chpasswd
	echo ssh user password: $PASSWORD
}

initialise_SSH

exec /usr/sbin/sshd -D -p 6666 -e "$@"