#!/usr/bin/env bash

#set and check kvm permissions

# If you have the ACL package for your distro installed, you can grant your user access via:
#sudo setfacl -m u:${USER}:rw /dev/kvm

#Otherwise, if access is managed via the kvm group:

[ $(stat -c "%G" /dev/kvm) = kvm ] && sudo usermod -aG kvm ${USER} && echo "Access granted."


#check access to /dev/kvm
[ -r /dev/kvm ] && [ -w /dev/kvm ] && echo "Success access to /dev/kvm" || echo "No access to /dev/kvm"


#set permission for firecracker binary executable
chmod +x firecracker
chmod 400 xenial.rootfs.id_rsa