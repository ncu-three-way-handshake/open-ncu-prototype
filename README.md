🌲 Magic Pinecone (OpenTPI Frontend Prototype)

This is a frontend prototype for the NCU (National Central University) campus service and AI-assisted course selection App, built with Flutter. The current project features a smooth-scrolling home interface, a fully structured weekly course schedule layout, and an underlying Tab navigation architecture that preserves UI states.

✨ Core Features & UI

* Home Feed: Built with CustomScrollView and Sliver widgets, seamlessly integrating sections such as "Upcoming Courses", "Campus Shortcuts", "Quick Actions", and "Campus Announcements".
Course Selection & Schedule System**: 
  * Supports NCU's complete 13-period (1~9, Z, A, B, C) weekly timetable.
  * Features a fully interactive layout—tapping on any empty period triggers the "AI Course Search" bottom sheet.
* **Stateful Navigation**: Utilizes an IndexedStack combined with multiple independent Navigators. This ensures that users will not lose their scroll progress or page state when switching between Home, News, Portal, and Settings tabs.
```
## 📁 Project Structure

open-ncu-prototype/
├── android/                 # Android-specific settings and native code
├── ios/                     # iOS-specific settings and native code
├── web/                     # Web-specific settings and static resources
│   ├── icons/               # Web app icons
│   ├── favicon.png          # Favicon
│   ├── index.html           # Web entry point
│   └── manifest.json        # PWA configuration
├── lib/                     # Core Dart code (Main working directory)
│   ├── components/          # Reusable UI components (Widgets)
│   │   ├── home/            # Home-specific components
│   │   │   └── section.dart
│   │   ├── announcement_card.dart  # Card for campus announcements
│   │   ├── course_card.dart        # Card for upcoming courses
│   │   ├── label.dart              # Tag components (e.g., Required, Announcement)
│   │   ├── quick_button.dart       # Long buttons for quick actions
│   │   └── shortcut.dart           # Circular icon buttons for shortcuts
│   ├── pages/               # Main application screens
│   │   ├── course.dart             # Course selection & schedule (incl. BottomSheet)
│   │   ├── curriculum.dart         # Curriculum view
│   │   ├── home.dart               # Home screen (Main Feed)
│   │   ├── news.dart               # News screen (Tab 2)
│   │   ├── portal.dart             # Portal screen (Tab 3)
│   │   └── setting.dart            # Settings screen (Tab 4)
│   └── main.dart            # Application entry point & NavigationBar routing
├── .gitignore               # Git ignore list
├── .metadata                # Flutter project metadata
├── analysis_options.yaml    # Dart static analysis & Linter rules
├── pubspec.yaml             # Flutter dependencies & project settings
├── pubspec.lock             # Dependency version lockfile
└── README.md                # Project documentation
```
🌲 神奇松果 (OpenTPI Frontend Prototype)

這是一個使用 Flutter 開發的中大校務與 AI 選課輔助 App 前端雛形。目前的專案主要完成了首頁的流暢滾動介面、選課課表的完整排版，以及支援狀態保留的底層 Tab 導覽架構。

✨ 核心功能與介面 (Features)

首頁資訊流：使用 CustomScrollView 與 Sliver 系列元件建構，流暢整合「接下來的課程」、「校園服務捷徑」、「快速功能表」與「校務公告」等區塊。
選課與課表系統：支援中大完整的 13 節次 ( 1~9, Z, A, B, C ) 週課表顯示。
實作全區塊可點擊的互動設計，點擊空白節次即可喚起「AI 選課搜尋」彈窗。
多重導覽狀態保留 (Stateful Navigation)：底層透過 IndexedStack 結合多個獨立 Navigator，確保使用者在切換首頁、訊息、校務系統、設定時，各頁面的瀏覽進度與狀態不會丟失。

📁 專案架構 
```
open-ncu-prototype/
├── android/                 # Android 平台專屬設定與原生代碼
├── ios/                     # iOS 平台專屬設定與原生代碼
├── web/                     # Web 平台專屬設定與靜態資源
│   ├── icons/               # Web 應用的圖示
│   ├── favicon.png          # 網頁標籤圖示
│   ├── index.html           # 網頁進入點
│   └── manifest.json        # PWA 設定檔
├── lib/                     # 核心 Dart 程式碼 (開發重心)
│   ├── components/          # 可重複使用的 UI 元件 (Widgets)
│   │   ├── home/            # 首頁專屬元件
│   │   │   └── section.dart
│   │   ├── announcement_card.dart  # 首頁校務公告的卡片設計
│   │   ├── course_card.dart        # 接下來課程的單筆卡片
│   │   ├── label.dart              # 標籤元件 (如必修、公告標籤)
│   │   ├── quick_button.dart       # 快速功能區塊的長條按鈕
│   │   └── shortcut.dart           # 捷徑區塊的圓形圖示按鈕
│   ├── pages/               # 各大主要功能頁面 (Screens)
│   │   ├── course.dart             # 選課與課表系統頁面 (包含 BottomSheet 搜尋)
│   │   ├── curriculum.dart         # 課表頁面 
│   │   ├── home.dart               # 首頁 (神奇松果主畫面)
│   │   ├── news.dart               # 訊息頁面 (Tab 2)
│   │   ├── portal.dart             # 校務系統頁面 (Tab 3)
│   │   └── setting.dart            # 設定頁面 (Tab 4)
│   └── main.dart            # 程式進入點與底層 NavigationBar 路由設定
├── .gitignore               # Git 版本控制忽略清單
├── .metadata                # Flutter 專案內部追蹤中繼資料
├── analysis_options.yaml    # Dart 靜態分析與 Linter 規範設定
├── pubspec.yaml             # Flutter 套件依賴管理與專案設定 (如 assets, fonts)
├── pubspec.lock             # 套件依賴的具體版本鎖定檔
└── README.md                # 專案說明文件
```
