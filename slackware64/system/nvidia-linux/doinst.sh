config() {
  NEW="$1"
  OLD="$(dirname $NEW)/$(basename $NEW .new)"
  # If there's no config file by that name, mv it over:
  if [ ! -r $OLD ]; then
    mv $NEW $OLD
  elif [ "$(cat $OLD | md5sum)" = "$(cat $NEW | md5sum)" ]; then
  # toss the redundant copy
    rm $NEW
  fi
  # Otherwise, we leave the .new copy for the admin to consider...
}
config etc/X11/xorg.conf.d/nvidia.conf.new
config etc/modprobe.d/nvidia.conf.new

if [ -f usr/libLIBDIRSUFFIX/xorg/modules/extensions/libglx.so ];then
  mv usr/libLIBDIRSUFFIX/xorg/modules/extensions/libglx.so usr/libLIBDIRSUFFIX/xorg/modules/extensions/libglx.so-prenvidia
fi

if lsmod|grep -q nouveau;then
  echo "You MUST reboot your system!"
  echo
fi

if [ ! -f lib/modules/`uname -r`/kernel/drivers/video/nvidia.ko ];then
  echo "You MUST rebuild the kernel module by launch the script:"
  echo "/usr/share/nvidia-linux/makekernelmodule.sh"
fi
