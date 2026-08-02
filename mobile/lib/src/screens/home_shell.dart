import 'dart:async';

import 'package:flutter/material.dart';

import 'dashboard_screen.dart';
import 'audio_practice_screen.dart';
import 'enquiries_screen.dart';
import 'exams_screen.dart';
import 'menu_screen.dart';
import 'courses_screen.dart';
import 'bookmarks_screen.dart';
import 'streak_screen.dart';
import 'certificates_screen.dart';
import 'leaderboard_screen.dart';
import 'gallery_screen.dart';
import 'notifications_screen.dart';
import 'packages_screen.dart';
import 'profile_screen.dart';
import 'results_screen.dart';
import '../config/backend_config.dart';
import '../navigation/app_section.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> with WidgetsBindingObserver {
  AppSection _activeSection = AppSection.dashboard;
  AppSection _primaryTab = AppSection.dashboard;
  int _refreshNonce = 0;
  AppLifecycleState _lifecycleState = AppLifecycleState.resumed;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _refreshTimer = Timer.periodic(const Duration(seconds: 45), (_) {
      if (_lifecycleState == AppLifecycleState.resumed) {
        _triggerRefresh();
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _lifecycleState = state;
    if (state == AppLifecycleState.resumed) {
      _triggerRefresh();
    }
  }

  void _triggerRefresh() {
    if (!mounted) {
      return;
    }

    setState(() {
      _refreshNonce++;
    });
  }

  Future<void> _showBackendSettings() async {
    final controller = TextEditingController(text: BackendConfig.baseUrl);
    try {
      final action = await showDialog<_BackendAction>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Backend connection'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Enter the Laravel API base URL that your phone can reach. '
                  'Example: http://192.168.1.20:8000/api/v1',
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    labelText: 'Backend URL',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.url,
                  autocorrect: false,
                  enableSuggestions: false,
                ),
                const SizedBox(height: 8),
                Text(
                  'Current value: ${BackendConfig.baseUrl}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(_BackendAction.reset),
                child: const Text('Use default'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(_BackendAction.save),
                child: const Text('Save'),
              ),
            ],
          );
        },
      );

      if (!mounted) {
        return;
      }

      if (action == _BackendAction.reset) {
        await BackendConfig.clearOverride();
        _triggerRefresh();
        return;
      }

      if (action == _BackendAction.save) {
        await BackendConfig.setBaseUrl(controller.text);
        _triggerRefresh();
      }
    } finally {
      controller.dispose();
    }
  }

  void _openSection(AppSection section) {
    setState(() {
      _activeSection = section;
      if (section == AppSection.dashboard ||
          section == AppSection.exams ||
          section == AppSection.audioPractice ||
          section == AppSection.profile) {
        _primaryTab = section;
      }
    });
    Navigator.of(context).maybePop();
  }

  int get _bottomIndex {
    return switch (_primaryTab) {
      AppSection.dashboard => 0,
      AppSection.exams => 1,
      AppSection.audioPractice => 2,
      AppSection.profile => 3,
      AppSection.results ||
      AppSection.notifications ||
      AppSection.packages ||
      AppSection.menu ||
      AppSection.gallery ||
      AppSection.enquiries ||
      AppSection.courses ||
      AppSection.bookmarks ||
      AppSection.streak ||
      AppSection.certificates ||
      AppSection.leaderboard => 0,
    };
  }

  Widget _buildScreen() {
    return switch (_activeSection) {
      AppSection.dashboard => DashboardScreen(onNavigate: _openSection),
      AppSection.exams => const ExamsScreen(),
      AppSection.audioPractice => const AudioPracticeScreen(),
      AppSection.results => const ResultsScreen(),
      AppSection.notifications => const NotificationsScreen(),
      AppSection.packages => const PackagesScreen(),
      AppSection.menu => const MenuScreen(),
      AppSection.gallery => const GalleryScreen(),
      AppSection.enquiries => const EnquiriesScreen(),
      AppSection.profile => const ProfileScreen(),
      AppSection.courses => const CoursesScreen(),
      AppSection.bookmarks => const BookmarksScreen(),
      AppSection.streak => const StreakScreen(),
      AppSection.certificates => const CertificatesScreen(),
      AppSection.leaderboard => const LeaderboardScreen(),
    };
  }

  @override
  Widget build(BuildContext context) {
    final drawerWidth = (MediaQuery.of(context).size.width * 0.84).clamp(280.0, 360.0).toDouble();
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            Image.asset(
              'lib/src/assets/logo.png',
              height: 28,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 10),
            const Text('ExamVerse'),
          ],
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
            tooltip: 'Open menu',
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.link_outlined),
            tooltip: 'Set backend URL',
            onPressed: _showBackendSettings,
          ),
          IconButton(
            icon: const Icon(Icons.refresh_outlined),
            tooltip: 'Sync backend data',
            onPressed: _triggerRefresh,
          ),
        ],
      ),
      drawer: Drawer(
        width: drawerWidth,
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                child: Row(
                  children: [
                    Image.asset(
                      'lib/src/assets/logo.png',
                      height: 34,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'More Sections',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                  ],
                ),
              ),
              _DrawerItem(
                icon: Icons.insights_outlined,
                label: 'Results',
                selected: _activeSection == AppSection.results,
                onTap: () => _openSection(AppSection.results),
              ),
              _DrawerItem(
                icon: Icons.notifications_none_outlined,
                label: 'Notifications',
                selected: _activeSection == AppSection.notifications,
                onTap: () => _openSection(AppSection.notifications),
              ),
              _DrawerItem(
                icon: Icons.workspace_premium_outlined,
                label: 'Packages',
                selected: _activeSection == AppSection.packages,
                onTap: () => _openSection(AppSection.packages),
              ),
              _DrawerItem(
                icon: Icons.menu_book_outlined,
                label: 'Menu',
                selected: _activeSection == AppSection.menu,
                onTap: () => _openSection(AppSection.menu),
              ),
              _DrawerItem(
                icon: Icons.photo_library_outlined,
                label: 'Gallery',
                selected: _activeSection == AppSection.gallery,
                onTap: () => _openSection(AppSection.gallery),
              ),
              _DrawerItem(
                icon: Icons.forum_outlined,
                label: 'Enquiries',
                selected: _activeSection == AppSection.enquiries,
                onTap: () => _openSection(AppSection.enquiries),
              ),
              _DrawerItem(
                icon: Icons.menu_book,
                label: 'Courses',
                selected: _activeSection == AppSection.courses,
                onTap: () => _openSection(AppSection.courses),
              ),
              _DrawerItem(
                icon: Icons.bookmark_outline,
                label: 'Bookmarks',
                selected: _activeSection == AppSection.bookmarks,
                onTap: () => _openSection(AppSection.bookmarks),
              ),
              _DrawerItem(
                icon: Icons.local_fire_department_outlined,
                label: 'Practice Streak',
                selected: _activeSection == AppSection.streak,
                onTap: () => _openSection(AppSection.streak),
              ),
              _DrawerItem(
                icon: Icons.workspace_premium,
                label: 'Certificates',
                selected: _activeSection == AppSection.certificates,
                onTap: () => _openSection(AppSection.certificates),
              ),
              _DrawerItem(
                icon: Icons.emoji_events_outlined,
                label: 'Leaderboard',
                selected: _activeSection == AppSection.leaderboard,
                onTap: () => _openSection(AppSection.leaderboard),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Use the bottom bar for Dashboard, Exams, Audio, and Profile.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: KeyedSubtree(
          key: ValueKey('${_activeSection.name}-$_refreshNonce'),
          child: _buildScreen(),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _bottomIndex,
        onDestinationSelected: (value) {
          if (value == 0) _openSection(AppSection.dashboard);
          if (value == 1) _openSection(AppSection.exams);
          if (value == 2) _openSection(AppSection.audioPractice);
          if (value == 3) _openSection(AppSection.profile);
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
            icon: Icon(Icons.graphic_eq_outlined),
            selectedIcon: Icon(Icons.graphic_eq),
            label: 'Audio',
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

enum _BackendAction { save, reset }

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
