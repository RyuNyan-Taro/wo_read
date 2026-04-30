import 'package:flutter/material.dart';
import 'package:wo_read/common/app_theme.dart';
import 'package:wo_read/cook/cook.dart';
import 'package:wo_read/gallery/gallery.dart';
import 'package:wo_read/home/home.dart';
import 'package:wo_read/record/record.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('のびのびノート'),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          HomeBody(),
          RecordBody(),
          CookBody(),
          GalleryBody(),
        ],
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        child: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (i) => setState(() => _selectedIndex = i),
          backgroundColor: Colors.white.withValues(alpha: 0.9),
          indicatorColor: AppColors.primaryContainer.withValues(alpha: 0.2),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'ホーム',
            ),
            NavigationDestination(
              icon: Icon(Icons.show_chart),
              label: '成長記録',
            ),
            NavigationDestination(
              icon: Icon(Icons.restaurant),
              label: '料理',
            ),
            NavigationDestination(
              icon: Icon(Icons.photo_library_outlined),
              selectedIcon: Icon(Icons.photo_library),
              label: 'ギャラリー',
            ),
          ],
        ),
      ),
    );
  }
}
