#!/bin/bash

# openwrt ipk pack/unpack tools

OUTPUT_DIR="$(pwd)/output"
SOURCE_DIR="$(pwd)/source"

mkdir "$OUTPUT_DIR" "$SOURCE_DIR" >/dev/null 2>&1

#找到对应的文件夹
if [ -z "$1" ] || [ "$1" = "-h" ]; then
    echo "usage: ./ipk-pack.sh [-d] package"
    exit
elif [ "$1" = "-d" ]; then
    TARGET_IPK="$2"
    echo "====================================="
    echo "package_file: $TARGET_IPK"
    echo "package_source: $SOURCE_DIR"
    echo "package_output: $OUTPUT_DIR"
    echo "====================================="
    rm -rf "$SOURCE_DIR"/{.,}*
    mkdir "$SOURCE_DIR/control" "$SOURCE_DIR/data"
    tar -xvzf "$TARGET_IPK" -C "$SOURCE_DIR"
    tar -xvzf "$SOURCE_DIR/control.tar.gz" -C "$SOURCE_DIR/control"
    tar -xvzf "$SOURCE_DIR/data.tar.gz" -C "$SOURCE_DIR/data"
    rm -rf "$SOURCE_DIR/control.tar.gz" "$SOURCE_DIR/data.tar.gz"
    exit
else
    TARGET_IPK="$1"
    echo "====================================="
    echo "package_name: $TARGET_IPK"
    echo "package_source: $SOURCE_DIR"
    echo "package_output: $OUTPUT_DIR"
    echo "====================================="
fi

cd "$OUTPUT_DIR"
rm -rf "$TARGET_IPK" control.tar.gz data.tar.gz debian-binary


# #压缩CONTROL目录
cd "$SOURCE_DIR/control"
tar -zcvf control.tar.gz .
mv control.tar.gz "$OUTPUT_DIR"
# #压缩data目录
cd "$SOURCE_DIR/data"
tar -zcvf data.tar.gz .
mv data.tar.gz "$OUTPUT_DIR"

if [ -f "$SOURCE_DIR/debian-binary" ]; then
    cp "$SOURCE_DIR/debian-binary" "$OUTPUT_DIR"
else
    echo 2.0 > "$OUTPUT_DIR/debian-binary"
fi
#压缩全部tar.gz生成tar.gz,并重命名成ipk
cd "$OUTPUT_DIR"
tar -cvzf "$TARGET_IPK" ./control.tar.gz ./data.tar.gz ./debian-binary
rm -rf control.tar.gz data.tar.gz debian-binary

