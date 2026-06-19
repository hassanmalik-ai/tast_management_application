import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../../core/constants/app_constants.dart';

/// Quick action buttons grid for the dashboard.
class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final actions = [
      {
        'icon': Iconsax.add_square,
        'label': 'Add Task',
        'color': const Color(0xFF4F46E5),
        'route': '/create-task',
      },
      {
        'icon': Iconsax.calendar_1,
        'label': 'Calendar',
        'color': const Color(0xFFF59E0B),
        'route': '/tasks',
      },
      {
        'icon': Iconsax.people,
        'label': 'Team',
        'color': const Color(0xFF22C55E),
        'route': '/profile',
      },
      {
        'icon': Iconsax.chart_2,
        'label': 'Reports',
        'color': const Color(0xFFEC4899),
        'route': '/tasks',
      },
    ];

    return Row(
      children: actions.map((action) {
        return Expanded(
          child: GestureDetector(
            onTap: () => context.push(action['route'] as String),
            child: Column(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: (action['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    action['icon'] as IconData,
                    size: 24,
                    color: action['color'] as Color,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  action['label'] as String,
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
