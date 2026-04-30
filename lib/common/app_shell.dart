import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
      appBar: AppBar(title: const Text('のびのびノート')),
      body: IndexedStack(
        index: _selectedIndex,
        children: const [HomeBody(), RecordBody(), CookBody(), GalleryBody()],
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        child: NavigationBarTheme(
          data: NavigationBarThemeData(
            labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((
              states,
            ) {
              final isSelected = states.contains(WidgetState.selected);

              return TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.primary : const Color(0xFFA8A29E),
              );
            }),
          ),
          child: NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (i) => setState(() => _selectedIndex = i),
            backgroundColor: Colors.white.withValues(alpha: 0.9),
            indicatorColor: AppColors.primaryContainer.withValues(alpha: 0.2),
            destinations: _footerIcons,
          ),
        ),
      ),
    );
  }
}

List<NavigationDestination> _footerIcons = [
  const NavigationDestination(
    icon: Icon(Icons.home_outlined, color: Color(0xFFA8A29E)),
    selectedIcon: Icon(Icons.home, color: Color(0xFFA8A29E)),
    label: 'ホーム',
  ),
  NavigationDestination(
    icon: SvgPicture.asset(
      'assets/images/icon/glow_icon.svg',
      width: 20,
      height: 18,
    ),
    label: '成長記録',
  ),
  NavigationDestination(
    icon: SvgPicture.asset(
      'assets/images/icon/cook_icon.svg',
      width: 20,
      height: 18,
    ),
    label: '料理',
  ),
  const NavigationDestination(
    icon: Icon(Icons.photo_library_outlined, color: Color(0xFFA8A29E)),
    selectedIcon: Icon(Icons.photo_library, color: Color(0xFFA8A29E)),
    label: 'ギャラリー',
  ),
];
