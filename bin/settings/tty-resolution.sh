#!/bin/sh

sudo apt-get install -y hwinfo

# Run this to get the full list.
# sudo hwinfo --framebuffer

mode=$(\
  sudo hwinfo --framebuffer \
  | tail -n2 \
  | head -n1 \
  | awk '{ print $2  }' \
  | sed 's/.$//' \
)

sudo cp --archive /etc/default/grub /etc/default/grub-COPY-$(date +"%Y%m%d%H%M%S")
sudo sed -i "s/\(GRUB_CMDLINE_LINUX_DEFAULT=\"\)/\1vga=$mode /" /etc/default/grub
