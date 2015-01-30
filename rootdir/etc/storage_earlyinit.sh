#!/sbin/static/busybox
export PATH=/sbin/static:/sbin

if [ -e /dev/lvpool/userdata ]; then
    busybox cp /init.fs.rc.lvm /init.fs.rc
    busybox cp /fstab.qcom.lvm /fstab.qcom
else
    busybox cp /init.fs.rc.std /init.fs.rc
    busybox cp /fstab.qcom.std /fstab.qcom
fi

