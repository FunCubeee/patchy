#!/system/bin/sh
MODDIR=${0%/*}
export PATH="$MODDIR/bin:$PATH"
BOOT_IMG="$1"
OUTPUT_IMG="$2"
WORK_DIR="/data/local/tmp/kernel_patcher"
MAGISKBOOT="/data/adb/magisk/magiskboot"

cd "$WORK_DIR"

cp "$BOOT_IMG" boot.img
$MAGISKBOOT unpack boot.img || exit 1

bpf_patcher kernel kernel.patched 2>/dev/null
if [ ! -f kernel.patched ]; then
    exit 1
fi
mv kernel.patched kernel

if [ -f kernel_dtb ]; then
    bpf_patcher kernel_dtb kernel_dtb.patched 2>/dev/null
    if [ -f kernel_dtb.patched ]; then
        mv kernel_dtb.patched kernel_dtb
    fi
fi

$MAGISKBOOT repack boot.img new-boot.img || exit 1

cp new-boot.img "$OUTPUT_IMG"

rm -f kernel kernel_dtb ramdisk.cpio second dtb recovery_dtbo header boot.img new-boot.img
