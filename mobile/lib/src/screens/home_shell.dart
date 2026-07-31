import 'package:flutter/material.dart';

import 'dashboard_screen.dart';
import 'enquiries_screen.dart';
import 'exams_screen.dart';
import 'menu_screen.dart';
import 'notifications_screen.dart';
import 'packages_screen.dart';
import 'profile_screen.dart';
import 'results_screen.dart';

enum _ShellScreen {
  dashboard,
  exams,
  results,
  notifications,
  packages,
  menu,
  enquiries,
  profile,
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  _ShellScreen _activeScreen = _ShellScreen.dashboard;
  _ShellScreen _primaryTab = _ShellScreen.dashboard;

  void _openScreen(_ShellScreen screen) {
    setState(() {
      _activeScreen = screen;
      if (screen == _ShellScreen.dashboard ||
          screen == _ShellScreen.exams ||
          screen == _ShellScreen.profile) {
        _primaryTab = screen;
      }
    });
    Navigator.of(context).maybePop();
  }

  int get _bottomIndex {
    return switch (_primaryTab) {
      _ShellScreen.dashboard => 0,
      _ShellScreen.exams => 1,
      _ShellScreen.profile => 2,
      _ShellScreen.results ||
      _ShellScreen.notifications ||
      _ShellScreen.packages ||
      _ShellScreen.menu ||
      _ShellScreen.enquiries => 0,
    };
  }

  Widget _buildScreen() {
    return switch (_activeScreen) {
      _ShellScreen.dashboard => const DashboardScreen(),
      _ShellScreen.exams => const ExamsScreen(),
      _ShellScreen.results => const ResultsScreen(),
      _ShellScreen.notifications => const NotificationsScreen(),
      _ShellScreen.packages => const PackagesScreen(),
      _ShellScreen.menu => const MenuScreen(),
      _ShellScreen.enquiries => const EnquiriesScreen(),
      _ShellScreen.profile => const ProfileScreen(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ExamVerse'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
            tooltip: 'Open menu',
          ),
        ),
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                child: Text(
                  'More Sections',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              _DrawerItem(
                icon: Icons.insights_outlined,
                label: 'Results',
                selected: _activeScreen == _ShellScreen.results,
                onTap: () => _openScreen(_ShellScreen.results),
              ),
              _DrawerItem(
                icon: Icons.notifications_none_outlined,
                label: 'Notifications',
                selected: _activeScreen == _ShellScreen.notifications,
                onTap: () => _openScreen(_ShellScreen.notifications),
              ),
              _DrawerItem(
                icon: Icons.workspace_premium_outlined,
                label: 'Packages',
                selected: _activeScreen == _ShellScreen.packages,
                onTap: () => _openScreen(_ShellScreen.packages),
              ),
              _DrawerItem(
                icon: Icons.menu_book_outlined,
                label: 'Menu',
                selected: _activeScreen == _ShellScreen.menu,
                onTap: () => _openScreen(_ShellScreen.menu),
              ),
              _DrawerItem(
                icon: Icons.forum_outlined,
                label: 'Enquiries',
                selected: _activeScreen == _ShellScreen.enquiries,
                onTap: () => _openScreen(_ShellScreen.enquiries),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Use the bottom bar for Dashboard, Exams, and Profile.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: _buildScreen(),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _bottomIndex,
        onDestinationSelected: (value) {
          if (value == 0) _openScreen(_ShellScreen.dashboard);
          if (value == 1) _openScreen(_ShellScreen.exams);
          if (value == 2) _openScreen(_ShellScreen.profile);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.space_dashboard_outlined),
            selectedIcon: Icon(Icons.space_dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.quiz_outlined),
            selectedIcon: Icon(Icons.quiz),
            label: 'Exams',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Material(
        color: selected ? scheme.primary.withValues(alpha: 0.10) : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: ListTile(
          leading: Icon(icon, color: selected ? scheme.primary : scheme.onSurfaceVariant),
          title: Text(
            label,
            style: TextStyle(
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              color: selected ? scheme.primary : null,
            ),
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
