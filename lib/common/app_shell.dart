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
                color: isSelected ? _selectedColor : _iconColor,
              );
            }),
            indicatorShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (i) => setState(() => _selectedIndex = i),
            backgroundColor: Colors.white.withValues(alpha: 0.9),
            indicatorColor: _selectedColor.withValues(alpha: 0.2),
            destinations: _footerIcons,
          ),
        ),
      ),
    );
  }
}

const Color _iconColor = Color(0xFFA8A29E);
const Color _selectedColor = AppColors.primaryContainer;

List<NavigationDestination> _footerIcons = [
  const NavigationDestination(
    icon: Icon(Icons.home_outlined, color: _iconColor),
    selectedIcon: Icon(Icons.home, color: _selectedColor),
    label: 'ホーム',
  ),
  NavigationDestination(
    icon: SvgPicture.asset(
      'assets/images/icon/glow_icon.svg',
      width: 20,
      height: 18,
      colorFilter: const ColorFilter.mode(Color(0xFFA8A29E), BlendMode.srcIn),
    ),
    selectedIcon: SvgPicture.asset(
      'assets/images/icon/glow_icon.svg',
      width: 20,
      height: 18,
      colorFilter: const ColorFilter.mode(Color(0xFFFF9E7A), BlendMode.srcIn),
    ),
    label: '成長記録',
  ),
  NavigationDestination(
    icon: SvgPicture.asset(
      'assets/images/icon/cook_icon.svg',
      width: 20,
      height: 18,
      colorFilter: const ColorFilter.mode(Color(0xFFA8A29E), BlendMode.srcIn),
    ),
    selectedIcon: SvgPicture.asset(
      'assets/images/icon/cook_icon.svg',
      width: 20,
      height: 18,
      colorFilter: const ColorFilter.mode(Color(0xFFFF9E7A), BlendMode.srcIn),
    ),
    label: '料理',
  ),
  const NavigationDestination(
    icon: Icon(Icons.photo_library_outlined, color: _iconColor),
    selectedIcon: Icon(Icons.photo_library, color: _selectedColor),
    label: 'ギャラリー',
  ),
];
