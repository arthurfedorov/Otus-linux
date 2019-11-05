#!/bin/bash

# Install Required Packages for Kernel Compilation
yum install -y  make gcc perl bc bison flex elfutils-libelf-devel openssl-devel grub2
# Download kernel
cd /usr/src/ && curl https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.9.99.tar.xz --output linux-4.9.99.tar.xz && tar -xvf linux-4.9.99.tar.xz && cd linux-4.9.99
# Compile kernel
cp /boot/config-$(uname -r) .config &&
make olddefconfig &&
make -j4 &&
make modules_install -j4 &&
make install -j4 
# Update GRUB
grub2-mkconfig -o /boot/grub2/grub.cfg
grub2-set-default 0
echo "Grub update done."
# Reboot VM
shutdown -r now
