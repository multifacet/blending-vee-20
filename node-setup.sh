git config --global user.name "Anjali05"
git config --global user.email "anjali@wisc.edu"



curl -LOJ https://github.com/firecracker-microvm/firecracker/releases/download/v0.15.2/firecracker-v0.15.2
mv firecracker-v0.15.2 firecracker
chmod +x firecracker


curl -fsSL -o hello-vmlinux.bin https://s3.amazonaws.com/spec.ccfc.min/img/hello/kernel/hello-vmlinux.bin
curl -fsSL -o hello-rootfs.ext4 https://s3.amazonaws.com/spec.ccfc.min/img/hello/fsfiles/hello-rootfs.ext4


#install docker from here
#https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-18-04


#gVisor setup
#https://github.com/google/gvisor
wget https://storage.googleapis.com/gvisor/releases/nightly/latest/runsc
wget https://storage.googleapis.com/gvisor/releases/nightly/latest/runsc.sha512
sha512sum -c runsc.sha512
chmod a+x runsc
sudo mv runsc /usr/local/bin



https://pip.pypa.io/en/stable/installing/