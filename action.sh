#!/system/bin/sh

MODDIR=${0%/*}
WORK_DIR="/data/local/tmp/kernel_patcher"
BOOT_DIR="/sdcard"
OUTPUT_DIR="/sdcard/Download"

mkdir -p "$WORK_DIR" "$OUTPUT_DIR"

echo ''
echo '__________         __         .__           '
echo '\______   \_____ _/  |_  ____ |  |__ ___.__.'
echo ' |     ___/\__  \\   __\/ ___\|  |  <   |  |'
echo ' |    |     / __ \|  | \  \___|   Y  \___  |'
echo ' |____|    (____  /__|  \___  >___|  / ____|'
echo '                \/          \/     \/\/     '
echo ''

BOOT_IMG="$BOOT_DIR/boot.img"

choose_key() {
    timeout 15 getevent -ql 2>/dev/null | awk '/KEY_VOLUMEUP.*DOWN/ {print "UP"; exit} /KEY_VOLUMEDOWN.*DOWN/ {print "DOWN"; exit}'
}

if [ ! -f "$BOOT_IMG" ]; then
    echo ""
    echo "======================================"
    echo "   boot.img not found in /sdcard"
    echo "======================================"
    echo "  Searching for other .img files..."
    echo "======================================"
    
    IMAGES=$(find /sdcard -name "*.img" ! -path "*/Android/*" 2>/dev/null)
    
    if [ -z "$IMAGES" ]; then
        echo "No .img files found on internal storage."
        exit 1
    fi

    IFS='
'
    SET_INDEX=1
    TOTAL_FILES=0
    for img in $IMAGES; do
        TOTAL_FILES=$((TOTAL_FILES + 1))
    done

    echo "Found $TOTAL_FILES images. Use buttons to select:"
    echo " [ Volume UP ]   -> Next File"
    echo " [ Volume DOWN ] -> Confirm / Select"
    echo "--------------------------------------"

    while true; do
        CURRENT_COUNT=1
        for img in $IMAGES; do
            if [ $CURRENT_COUNT -eq $SET_INDEX ]; then
                TARGET_IMAGE="$img"
                echo "CURRENT: $TARGET_IMAGE"
                break
            fi
            CURRENT_COUNT=$((CURRENT_COUNT + 1))
        done

        KEY=$(choose_key)

        if [ "$KEY" = "UP" ]; then
            SET_INDEX=$((SET_INDEX + 1))
            if [ $SET_INDEX -gt $TOTAL_FILES ]; then
                SET_INDEX=1
            fi
        elif [ "$KEY" = "DOWN" ]; then
            BOOT_IMG="$TARGET_IMAGE"
            echo "Selected: $BOOT_IMG"
            break
        else
            echo "Timeout. No button pressed."
            exit 1
        fi
    done
fi

echo "Selected: $BOOT_IMG"

cp "$BOOT_IMG" "$WORK_DIR/boot.img"
chmod 644 "$WORK_DIR/boot.img"

TIMESTAMP=$(date +%Y%m%d_%H%M%S)

echo "Starting patching process..."
sh "$MODDIR/patch.sh" "$WORK_DIR/boot.img" "$OUTPUT_DIR/bpfpatched_$TIMESTAMP.img"

if [ $? -eq 0 ] && [ -f "$OUTPUT_DIR/bpfpatched_$TIMESTAMP.img" ]; then
    echo ""
    echo "Success: $OUTPUT_DIR/bpfpatched_$TIMESTAMP.img"
    rm -f "$WORK_DIR/boot.img"
else
    echo "Patching failed"
    exit 1
fi

echo "Done."
