#!/usr/bin/env bash
set -e

echo "========================================================"
echo "  中国矿业大学（北京）研究生逐周逐日智能课表 - APK 自动编译脚本"
echo "========================================================"

if command -v ./gradlew >/dev/null 2>&1; then
    GRADLE_CMD="./gradlew"
elif command -v gradle >/dev/null 2>&1; then
    GRADLE_CMD="gradle"
else
    echo "[错误] 未检测到 gradle 命令。请使用 Android Studio 打开本目录，或先安装 Gradle 8.2+。"
    exit 1
fi

echo "[1/2] 正在执行 Gradle 构建 (assembleDebug & assembleRelease)..."
$GRADLE_CMD assembleDebug assembleRelease --no-daemon

echo "[2/2] 构建完成！生成的 APK 安装包位置如下："
ls -lh app/build/outputs/apk/debug/*.apk app/build/outputs/apk/release/*.apk 2>/dev/null || true
