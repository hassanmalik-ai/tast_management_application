import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../shared/providers/app_providers.dart';
import '../constants/app_constants.dart';

/// Custom bottom navigation bar with a floating design and animated indicator.
class BottomNavBar extends ConsumerWidget {
  final void Function(int) onTabChanged;

  const BottomNavBar({super.key, required this.onTabChanged});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(selectedTabProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF1E293B).withOpacity(0.95)
            : Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(AppConstants.radiusXl),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.05)
              : Colors.black.withOpacity(0.04),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppConstants.radiusXl),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(4, (index) {
              final isSelected = currentIndex == index;
              final item = _navItems[index];

              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    ref.read(selectedTabProvider.notifier).state = index;
                    onTabChanged(index);
                  },
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: AppConstants.animMedium,
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? theme.colorScheme.primary.withOpacity(0.1)
                          : Colors.transparent,
                      borderRadius:
                          BorderRadius.circular(AppConstants.radiusMd),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isSelected ? item['activeIcon'] : item['icon'],
                          size: 24,
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurface.withOpacity(0.4),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item['label'] as String,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: isSelected
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurface
                                    .withOpacity(0.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    ).animate().slideY(
          begin: 1.0,
          end: 0,
          duration: 500.ms,
          curve: Curves.easeOutCubic,
        );
  }

  static final List<Map<String, dynamic>> _navItems = [
    {
      'label': 'Home',
      'icon': Iconsax.home_1,
      'activeIcon': Iconsax.home_15,
    },
    {
      'label': 'Tasks',
      'icon': Iconsax.task_square,
      'activeIcon': Iconsax.task_square5,
    },
    {
      'label': 'Alerts',
      'icon': Iconsax.notification,
      'activeIcon': Iconsax.notification5,
    },
    {
      'label': 'Profile',
      'icon': Iconsax.profile_circle,
      'activeIcon': Iconsax.profile_circle5,
    },
  ];
}
