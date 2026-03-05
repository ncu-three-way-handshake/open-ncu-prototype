🌲 Magic Pinecone (OpenTPI Frontend Prototype)

This is a frontend prototype for the NCU (National Central University) campus service and AI-assisted course selection App, built with Flutter. The current project features a smooth-scrolling home interface, a fully structured weekly course schedule layout, and an underlying Tab navigation architecture that preserves UI states.

✨ Core Features & UI

* Home Feed: Built with CustomScrollView and Sliver widgets, seamlessly integrating sections such as "Upcoming Courses", "Campus Shortcuts", "Quick Actions", and "Campus Announcements".
Course Selection & Schedule System**: 
  * Supports NCU's complete 13-period (1~9, Z, A, B, C) weekly timetable.
  * Features a fully interactive layout—tapping on any empty period triggers the "AI Course Search" bottom sheet.
* **Stateful Navigation**: Utilizes an IndexedStack combined with multiple independent Navigators. This ensures that users will not lose their scroll progress or page state when switching between Home, News, Portal, and Settings tabs.

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
