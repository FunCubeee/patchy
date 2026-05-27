#!/system/bin/sh
MODDIR=${0%/*}
WORK_DIR="/data/local/tmp/kernel_patcher"

mkdir -p "$WORK_DIR"
cp -r "$MODDIR/mtk_bpf_patcher" "$WORK_DIR/"
cp "$MODDIR/patch.sh" "$WORK_DIR/"

chmod -R +x "$WORK_DIR/patch.sh"
chmod -R +x "$WORK_DIR/mtk_bpf_patcher"

echo "$(date): Kernel Patcher ready" > "$WORK_DIR/patcher.log"
