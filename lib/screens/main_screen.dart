import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'home_screen.dart';
import 'progress_screen.dart';
import 'settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    ProgressScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined),
            activeIcon: const Icon(Icons.home),
            label: AppLocalizations.of(context)?.home ?? 'Home',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.trending_up_outlined),
            activeIcon: const Icon(Icons.trending_up),
            label: AppLocalizations.of(context)?.progress ?? 'Progress',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings_outlined),
            activeIcon: const Icon(Icons.settings),
            label: AppLocalizations.of(context)?.settings ?? 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).bottomNavigationBarTheme.selectedItemColor ?? const Color(0xFF007AFF),
        unselectedItemColor: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor ?? const Color(0xFF888888),
        elevation: 0,
        backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor ?? Theme.of(context).cardColor,
      ),
    );
  }
}
