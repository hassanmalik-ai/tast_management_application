import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/mock_data/mock_data.dart';
import '../tasks/providers/task_providers.dart';
import '../../shared/models/task_model.dart';
import 'widgets/stat_card.dart';
import 'widgets/task_summary_card.dart';
import 'widgets/weekly_chart.dart';
import 'widgets/quick_actions.dart';

/// Dashboard / Home screen with stats, tasks, chart, and quick actions.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final user = MockData.user;
    final tasksAsync = ref.watch(tasksProvider);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            // ── Header ──────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  children: [
                    // User avatar
                    CircleAvatar(
                      radius: 24,
                      backgroundColor:
                          theme.colorScheme.primary.withOpacity(0.1),
                      child: Text(
                        user.fullName[0],
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getGreeting(),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface
                                  .withOpacity(0.5),
                            ),
                          ),
                          Text(
                            user.fullName,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Notification bell
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: theme.colorScheme.outline.withOpacity(0.15),
                        ),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(
                            Iconsax.notification,
                            size: 22,
                            color: theme.colorScheme.onSurface,
                          ),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.error,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
                    .animate()
                    .fadeIn(duration: 400.ms)
                    .slideY(begin: -0.2, end: 0),
              ),
            ),

            // ── Search Bar ──────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius:
                        BorderRadius.circular(AppConstants.radiusMd),
                    border: Border.all(
                      color: theme.colorScheme.outline.withOpacity(0.15),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Iconsax.search_normal,
                        size: 20,
                        color: theme.colorScheme.onSurface.withOpacity(0.3),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Search tasks...',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withOpacity(0.3),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color:
                              theme.colorScheme.primary.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Iconsax.setting_4,
                          size: 18,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                )
                    .animate()
                    .fadeIn(delay: 100.ms, duration: 400.ms)
                    .slideY(begin: 0.1, end: 0),
              ),
            ),

            // ── Stats Grid ──────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.5,
                  children: [
                    tasksAsync.when(
                      data: (tasks) {
                        final completedCount = tasks.where((t) => t.status == TaskStatus.completed).length;
                        return StatCard(
                          title: 'Completed',
                          value: '$completedCount',
                          icon: Iconsax.tick_circle5,
                          color: AppColors.success,
                        );
                      },
                      loading: () => const CircularProgressIndicator(),
                      error: (_, __) => const SizedBox(),
                    ),
                    tasksAsync.when(
                      data: (tasks) {
                        final pendingCount = tasks.where((t) => t.status != TaskStatus.completed && t.status != TaskStatus.overdue).length;
                        return StatCard(
                          title: 'Pending',
                          value: '$pendingCount',
                          icon: Iconsax.clock5,
                          color: AppColors.warning,
                        );
                      },
                      loading: () => const CircularProgressIndicator(),
                      error: (_, __) => const SizedBox(),
                    ),
                    tasksAsync.when(
                      data: (tasks) {
                        final overdueCount = tasks.where((t) => t.status == TaskStatus.overdue).length;
                        return StatCard(
                          title: 'Overdue',
                          value: '$overdueCount',
                          icon: Iconsax.danger5,
                          color: AppColors.error,
                        );
                      },
                      loading: () => const CircularProgressIndicator(),
                      error: (_, __) => const SizedBox(),
                    ),
                    tasksAsync.when(
                      data: (tasks) {
                        final completedCount = tasks.where((t) => t.status == TaskStatus.completed).length;
                        final total = tasks.length;
                        final score = total == 0 ? 0 : (completedCount / total * 100).toInt();
                        return StatCard(
                          title: 'Productivity',
                          value: '$score%',
                          icon: Iconsax.chart_15,
                          color: AppColors.primaryLight,
                        );
                      },
                      loading: () => const CircularProgressIndicator(),
                      error: (_, __) => const SizedBox(),
                    ),
                  ]
                      .animate(interval: 100.ms)
                      .fadeIn(duration: 400.ms)
                      .scale(begin: const Offset(0.95, 0.95)),
                ),
              ),
            ),

            // ── Today's Tasks ───────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Today's Tasks",
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'See All',
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ).animate().fadeIn(delay: 400.ms),
              ),
            ),

            SliverToBoxAdapter(
              child: SizedBox(
                height: 190,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                  itemCount: tasksAsync.when(
                    data: (tasks) => tasks.take(4).length,
                    loading: () => 0,
                    error: (_, __) => 0,
                  ),
                  itemBuilder: (context, index) {
                    return tasksAsync.when(
                      data: (tasks) => Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: TaskSummaryCard(task: tasks[index]),
                      ),
                      loading: () => const SizedBox(),
                      error: (_, __) => const SizedBox(),
                    );
                  },
                ),
              )
                  .animate()
                  .fadeIn(delay: 500.ms, duration: 400.ms)
                  .slideX(begin: 0.1, end: 0),
            ),

            // ── Quick Actions ───────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quick Actions',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const QuickActions(),
                  ],
                ),
              ).animate().fadeIn(delay: 600.ms, duration: 400.ms),
            ),

            // ── Weekly Chart ────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                child: const WeeklyChart(),
              ).animate().fadeIn(delay: 700.ms, duration: 400.ms),
            ),

            // Bottom padding for nav bar
            const SliverToBoxAdapter(
              child: SizedBox(height: 120),
            ),
          ],
        ),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning 🌅';
    if (hour < 17) return 'Good Afternoon ☀️';
    return 'Good Evening 🌙';
  }
}
