#!/bin/bash

# Step Install Kitsune Mask for Android Emulator
# Автоматическая установка Kitsune Mask на эмулятор

echo "=== Kitsune Mask Installation Script ==="
echo "Starting installation process..."

# Проверка подключения ADB
echo "1. Checking ADB connection..."
if ! adb devices | grep -q "device$"; then
    echo "❌ Error: No device connected via ADB"
    exit 1
fi
echo "✅ ADB connection OK"

# Проверка root доступа
echo "2. Checking root access..."
if ! adb shell "su -c 'id'" | grep -q "uid=0"; then
    echo "❌ Error: Root access not available"
    echo "Please enable root in emulator settings first"
    exit 1
fi
echo "✅ Root access OK"

# Создание резервных копий
echo "3. Creating backup copies of existing su..."
adb shell "su -c 'cp /system/xbin/su /sdcard/Download/su_backup'"
adb shell "su -c 'cp /system/bin/su /sdcard/Download/su_bin_backup'"

# Проверка создания резервных копий
if adb shell "ls /sdcard/Download/su_backup" 2>/dev/null; then
    echo "✅ Backup created: /sdcard/Download/su_backup"
else
    echo "❌ Failed to create backup"
fi

if adb shell "ls /sdcard/Download/su_bin_backup" 2>/dev/null; then
    echo "✅ Backup created: /sdcard/Download/su_bin_backup"
else
    echo "❌ Failed to create backup"
fi

# Удаление встроенного su
echo "4. Removing built-in su binaries..."
adb shell "su -c 'rm -f /system/xbin/su'"
adb shell "su -c 'rm -f /system/bin/su'"

# Проверка удаления
if ! adb shell "ls /system/xbin/su" 2>/dev/null; then
    echo "✅ Built-in su removed from /system/xbin/"
else
    echo "❌ Failed to remove /system/xbin/su"
fi

if ! adb shell "ls /system/bin/su" 2>/dev/null; then
    echo "✅ Built-in su removed from /system/bin/"
else
    echo "❌ Failed to remove /system/bin/su"
fi

# Проверка установки Kitsune Mask
echo "5. Checking Kitsune Mask installation..."
if adb shell "pm list packages | grep huskydg.magisk"; then
    echo "✅ Kitsune Mask is installed"
else
    echo "❌ Kitsune Mask not found"
    echo "Please install Kitsune Mask APK first"
    exit 1
fi

# Запуск Kitsune Mask
echo "6. Launching Kitsune Mask..."
adb shell "am start -a android.intent.action.MAIN -c android.intent.category.LAUNCHER -p io.github.huskydg.magisk"

echo ""
echo "=== Installation Steps Complete ==="
echo ""
echo "Next steps:"
echo "1. In Kitsune Mask, click 'Install'"
echo "2. Uncheck 'Patch recovery image instead of boot'"
echo "3. Check 'Direct install modify /system directly'"
echo "4. Click 'Install'"
echo "5. Reboot emulator"
echo ""
echo "Backup files saved to:"
echo "- /sdcard/Download/su_backup"
echo "- /sdcard/Download/su_bin_backup"
echo ""
echo "Script completed successfully!" 
