import 'package:flutter/material.dart';
import 'package:prototype/pages/course.dart';
import 'package:prototype/pages/home.dart';
import 'package:prototype/pages/news.dart';
import 'package:prototype/pages/portal.dart';
import 'package:prototype/pages/setting.dart';
import 'package:prototype/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _currentIndex = 0;

  // Each tab gets its own GlobalKey so its Navigator state is preserved.
  final _tabKeys = List.generate(5, (_) => GlobalKey<NavigatorState>());

  // The root page builder for each tab.
  static final _tabBuilders = <Widget Function()>[
    () => const HomePage(),
    () => const NewsPage(),
    () => const PortalPage(),
    () => const CourseSelectionPage(),
    () => const SettingPage(),
  ];

  static const _destinations = [
    NavigationDestination(icon: Icon(Icons.home), label: '首頁'),
    NavigationDestination(icon: Icon(Icons.campaign), label: '訊息'),
    NavigationDestination(icon: Icon(Icons.book), label: '校務系統'),
    NavigationDestination(icon: Icon(Icons.calendar_view_week), label: '選課'),
    NavigationDestination(icon: Icon(Icons.settings), label: '設定'),
  ];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, themeMode, _) => MaterialApp(
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: themeMode,
        // Pop within the current tab first; if already at root, allow system back.
        home: PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, _) async {
            if (didPop) return;
            final navState = _tabKeys[_currentIndex].currentState;
            if (navState != null && navState.canPop()) {
              navState.pop();
            }
          },
          child: Scaffold(
            body: IndexedStack(
              index: _currentIndex,
              children: List.generate(5, (i) => _buildTabNavigator(i)),
            ),
            bottomNavigationBar: NavigationBar(
              onDestinationSelected: (int index) {
                if (index == _currentIndex) {
                  // Tapping the active tab pops to its root.
                  _tabKeys[index].currentState?.popUntil((r) => r.isFirst);
                } else {
                  setState(() => _currentIndex = index);
                }
              },
              selectedIndex: _currentIndex,
              destinations: _destinations,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabNavigator(int index) {
    return Navigator(
      key: _tabKeys[index],
      onGenerateRoute: (_) =>
          MaterialPageRoute(builder: (_) => _tabBuilders[index]()),
    );
  }
}
