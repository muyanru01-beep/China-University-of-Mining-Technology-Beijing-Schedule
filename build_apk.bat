@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion
cd /d "%~dp0"

echo ====================================================================
echo   中国矿业大学（北京）研究生逐周逐日智能课表 - APK 自动下载与编译脚本
echo ====================================================================
echo.

:: 1. 检查 Java (JDK 17+)
where java >nul 2>nul
if %errorlevel% neq 0 (
    echo [错误] 未检测到 Java 环境 ^(JDK 17+^)。
    echo        如果您电脑上装有 Android Studio，可直接用 Android Studio 打开本文件夹，
    echo        点击顶部菜单 Build -^> Build Bundle^(s^) / APK^(s^) -^> Build APK^(s^) 一键生成！
    echo        或者在 GitHub 网页上传本文件夹，由 GitHub Actions 自动为您编译 APK。
    pause
    exit /b 1
)

:: 2. 自动检测 Android SDK 路径并生成 local.properties
if not exist "local.properties" (
    set "SDK_FOUND="
    if defined ANDROID_HOME (
        if exist "!ANDROID_HOME!" set "SDK_FOUND=!ANDROID_HOME!"
    )
    if not defined SDK_FOUND (
        if defined ANDROID_SDK_ROOT (
            if exist "!ANDROID_SDK_ROOT!" set "SDK_FOUND=!ANDROID_SDK_ROOT!"
        )
    )
    if not defined SDK_FOUND (
        if exist "%LOCALAPPDATA%\Android\Sdk" set "SDK_FOUND=%LOCALAPPDATA%\Android\Sdk"
    )
    if defined SDK_FOUND (
        echo [信息] 已自动检测到本地 Android SDK: !SDK_FOUND!
        set "SDK_ESCAPED=!SDK_FOUND:\=\\!"
        echo sdk.dir=!SDK_ESCAPED!> local.properties
    ) else (
        echo [错误] 未在电脑上检测到 Android SDK ^(%LOCALAPPDATA%\Android\Sdk^)。
        echo        本地编译 APK 必须依赖 Android SDK ^(约 1~2 GB^)。
        echo        如果您不想在电脑安装庞大的 Android Studio / SDK，强烈推荐使用【GitHub 免安装云端编译】：
        echo        1. 将本文件夹上传至您的 GitHub 仓库
        echo        2. 点击仓库顶部的 Actions 标签页 -^> 点击 Build CUMTB Schedule Android APK
        echo        3. 等待 1 分钟即可直接下载现成的 cumtb-schedule-apk.zip ^(内含 APK 安装包^)。
        echo.
        pause
        exit /b 1
    )
)

:: 3. 如果电脑未全局安装 gradle，则自动下载便携版 Gradle 8.5 到本地 .gradle_portable 目录
set "GRADLE_CMD="
where gradle >nul 2>nul
if %errorlevel% equ 0 (
    set "GRADLE_CMD=gradle"
) else (
    if exist ".gradle_portable\gradle-8.5\bin\gradle.bat" (
        set "GRADLE_CMD=.gradle_portable\gradle-8.5\bin\gradle.bat"
    ) else (
        echo [信息] 系统 PATH 中未找到 gradle，正在自动为您下载便携版 Gradle 8.5...
        mkdir ".gradle_portable" 2>nul
        powershell -Command "Invoke-WebRequest -Uri 'https://services.gradle.org/distributions/gradle-8.5-bin.zip' -OutFile '.gradle_portable\gradle.zip'"
        if not exist ".gradle_portable\gradle.zip" (
            echo [错误] 下载 Gradle 8.5 失败，请检查网络连接。
            pause
            exit /b 1
        )
        echo [信息] 正在解压 Gradle 8.5...
        powershell -Command "Expand-Archive -Path '.gradle_portable\gradle.zip' -DestinationPath '.gradle_portable' -Force"
        set "GRADLE_CMD=.gradle_portable\gradle-8.5\bin\gradle.bat"
    )
)

echo.
echo [1/2] 正在执行 Gradle 编译生成 APK 安装包...
call "!GRADLE_CMD!" assembleDebug assembleRelease --no-daemon
if %errorlevel% neq 0 (
    echo.
    echo [错误] 编译过程中出现错误，请检查上方日志输出 ^(如 JDK 版本需为 JDK 17^)。
    pause
    exit /b 1
)

:: 4. 将生成的 APK 直接复制到当前根目录，方便直接查看！
if exist "app\build\outputs\apk\debug\app-debug.apk" (
    copy /Y "app\build\outputs\apk\debug\app-debug.apk" ".\矿大逐周课表_debug.apk" >nul
)
if exist "app\build\outputs\apk\release\app-release.apk" (
    copy /Y "app\build\outputs\apk\release\app-release.apk" ".\矿大逐周课表_release.apk" >nul
)

echo.
echo ====================================================================
echo [2/2] 编译成功！生成的 APK 安装包位置如下：
echo   1. 当前文件夹根目录：
echo      - %~dp0矿大逐周课表_release.apk  ^(推荐直接发送到手机安装^)
echo      - %~dp0矿大逐周课表_debug.apk
echo   2. 原始构建输出目录：
echo      - app\build\outputs\apk\release\app-release.apk
echo      - app\build\outputs\apk\debug\app-debug.apk
echo ====================================================================
pause
