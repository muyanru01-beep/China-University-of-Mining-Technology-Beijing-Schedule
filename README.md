# 中国矿业大学（北京）研究生逐周逐日智能课表 Android 工程

本工程基于《中国矿业大学（北京）研究生信息管理系统（2026-20271学期）》课表截图与[教务处2026-2027学年第一学期排课通知](https://jwc.cumtb.edu.cn/info/1068/6105.htm)构建，内置完整 20 周（`2026-08-31` 至 `2027-01-17`）逐周日历、逐日课程、逐节（第1~12节，含沙河校区沙教一/二号楼与沙教三/四号楼第3、4节错峰时间自动匹配）与逐小时（`08:00~22:00`）时间轴视图，并支持在手机端直接导入/导出课表 `.json` 文件且通过 `localStorage` 自动持久化保存修改。

---

## 一、如何一键获取 `.apk` 安装包（3 种方式任选）

### 方式 1：免配环境 · GitHub Actions 云端自动编译 APK（最省心，无需本地安装 Android Studio）
本项目已内置 `.github/workflows/build-apk.yml` 自动打包流水线：
1. 在 GitHub 新建一个仓库（公开或私有均可），将解压后的本文件夹全部内容上传推送到仓库。
2. 点击 GitHub 仓库顶部的 **Actions** 标签页，等待 `Build CUMTB Schedule Android APK` 任务运行完成（约 1~2 分钟）。
3. 在运行完成的页面底部 **Artifacts** 区域点击 **`cumtb-schedule-apk`** 即可直接下载编译并签名好的 `app-debug.apk` 和 `app-release.apk` 到手机安装。

### 方式 2：本地一键脚本或 Android Studio 编译
- **使用 Android Studio**：打开 Android Studio -> `Open` 选择本工程目录 -> 等待 Gradle 同步完成后，点击顶部菜单 **`Build` -> `Build Bundle(s) / APK(s)` -> `Build APK(s)`**，即可在 `app/build/outputs/apk/debug/app-debug.apk` 获得安装包。
- **使用命令行一键脚本**：
  - Windows：双击运行 `build_apk.bat`
  - macOS / Linux：在终端执行 `./build_apk.sh`

### 方式 3：手机浏览器直接离线/桌面图标运行（免编译即刻使用）
工程内的 `app/src/main/assets/index.html` 是完全自包含的单文件移动应用，你也可以直接将该文件发送至手机，用 Chrome / Edge / 系统浏览器打开并点击 **“添加到主屏幕”**，即可获得与原生 App 一致的全屏使用体验。

---

## 二、工程目录结构说明

```text
CUMTBScheduleAndroid/
├── .github/workflows/
│   └── build-apk.yml              # GitHub Actions 云端自动打包 APK 工作流
├── app/
│   ├── build.gradle               # Android App 模块构建配置 (minSdk 24, targetSdk 34)
│   └── src/main/
│       ├── AndroidManifest.xml    # 应用清单与权限声明
│       ├── assets/
│       │   ├── index.html                        # 内置课表交互前端 (已对接 AndroidBridge 与持久化)
│       │   ├── cumtb_schedule_2026_2027_1.json   # AI 解析生成的 2026-2027-1 完整结构化课表 JSON
│       │   └── manifest.json                     # 移动端全屏配置清单
│       ├── java/cn/edu/cumtb/schedule/
│       │   └── MainActivity.java  # 原生容器：支持文件选择器读入外部 JSON 与系统文件保存导出 JSON
│       └── res/                   # 应用图标 (mipmap-*) 与名称资源
├── build.gradle                   # 根项目 Gradle 配置
├── settings.gradle                # Gradle 仓库与模块配置
├── gradle.properties              # JVM 与 AndroidX 属性配置
├── build_apk.sh                   # macOS / Linux 一键编译 APK 脚本
└── build_apk.bat                  # Windows 一键编译 APK 脚本
```
