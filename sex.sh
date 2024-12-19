#!/bin/sh

SEXTREE_DIR=$(pwd)
export PATH=$PATH:~/.local/usr/bin
max_retries=50
timeout=1
ARCH=$(uname -m)

if [ "$ARCH" = "x86_64" ]; then
  ARCH_ALT=amd64
elif [ "$ARCH" = "aarch64" ]; then
  ARCH_ALT=arm64
else
  printf "Unsupported CPU architecture: ${ARCH}"
  exit 1
fi

if [ ! -e $SEXTREE_DIR/.installed ]; then
  echo "#######################################################################################"
  echo "#"
  echo "#                                      Foxytoux INSTALLER"
  echo "#"
  echo "#                           Copyright (C) 2024, RecodeStudios.Cloud"
  echo "#"
  echo "#"
  echo "#######################################################################################"

  read -p "Do you want to install Ubuntu? (YES/no): " install_ubuntu
fi

case $install_ubuntu in
  [yY][eE][sS])
    wget --tries=$max_retries --timeout=$timeout --no-hsts -O /home/$USER/otrofs.tar.gz \
      "http://cdimage.ubuntu.com/ubuntu-base/releases/20.04/release/ubuntu-base-20.04.4-base-${ARCH_ALT}.tar.gz"
    tar -xf /home/$USER/otrofs.tar.gz -C $SEXTREE_DIR
    ;;
  *)
    echo "Skipping Ubuntu installation."
    ;;
esac

if [ ! -e $SEXTREE_DIR/.installed ]; then
  mkdir $SEXTREE_DIR/usr/local/bin -p
  wget --tries=$max_retries --timeout=$timeout --no-hsts -O $SEXTREE_DIR/usr/local/bin/potro "https://raw.githubusercontent.com/nhansp/wagrh/main/potro-${ARCH}"

  while [ ! -s "$SEXTREE_DIR/usr/local/bin/potro" ]; do
    rm $SEXTREE_DIR/usr/local/bin/potro -rf
    wget --tries=$max_retries --timeout=$timeout --no-hsts -O $SEXTREE_DIR/usr/local/bin/potro "https://raw.githubusercontent.com/nhansp/wagrh/main/potro-${ARCH}"

    if [ -s "$SEXTREE_DIR/usr/local/bin/potro" ]; then
      chmod 755 $SEXTREE_DIR/usr/local/bin/potro
      break
    fi

    chmod 755 $SEXTREE_DIR/usr/local/bin/potro
    sleep 1
  done

  chmod 755 $SEXTREE_DIR/usr/local/bin/potro
fi

if [ ! -e $SEXTREE_DIR/.installed ]; then
  printf "nameserver 1.1.1.1\nnameserver 1.0.0.1" > ${SEXTREE_DIR}/etc/resolv.conf
  rm -rf /home/$USER/otrofs.tar.gz /tmp/sbin
  touch $SEXTREE_DIR/.installed
fi

CYAN='\e[0;36m'
WHITE='\e[0;37m'

RESET_COLOR='\e[0m'

display_gg() {
  echo -e "${WHITE}___________________________________________________${RESET_COLOR}"
  echo -e ""
  echo -e "           ${CYAN}-----> Mission Completed ! <----${RESET_COLOR}"
}

clear
display_gg

$SEXTREE_DIR/usr/local/bin/potro \
  --rootfs="${SEXTREE_DIR}" \
  -0 -w "/root" -b /dev -b /sys -b /proc -b /etc/resolv.conf --kill-on-exit
