import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/widgets/bottom_nav_bar.dart';
import '../../shared/providers/app_providers.dart';

/// App shell with bottom navigation bar.
/// Wraps the main content screens (Dashboard, Tasks, Notifications, Profile).
class AppShell extends ConsumerWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  static final List<String> _routes = [
    '/',
    '/tasks',
    '/notifications',
    '/profile',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: child,
      extendBody: true,
      bottomNavigationBar: BottomNavBar(
        onTabChanged: (index) {
          context.go(_routes[index]);
        },
      ),
      floatingActionButton: _buildFAB(context, ref),
    );
  }

  Widget? _buildFAB(BuildContext context, WidgetRef ref) {
    final currentTab = ref.watch(selectedTabProvider);
    if (currentTab > 1) return null; // Only show on Home and Tasks tabs

    return FloatingActionButton(
      onPressed: () => context.push('/create-task'),
      elevation: 4,
      child: const Icon(Icons.add_rounded, size: 28),
    );
  }
}
