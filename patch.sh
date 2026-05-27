#!/system/bin/sh
MODDIR=${0%/*}
export PATH="$MODDIR/bin:$PATH"
BOOT_IMG="$1"
OUTPUT_IMG="$2"
WORK_DIR="/data/local/tmp/kernel_patcher"
MAGISKBOOT="/data/adb/magisk/magiskboot"
cd "$WORK_DIR"
cp "$BOOT_IMG" boot.img
$MAGISKBOOT unpack boot.img
bpf_patcher kernel kernel.patched
mv kernel.patched kernel
$MAGISKBOOT repack boot.img new-boot.img
cp new-boot.img "$OUTPUT_IMG"
rm -f kernel kernel_dtb ramdisk.cpio second dtb recovery_dtbo header boot.img new-boot.img
