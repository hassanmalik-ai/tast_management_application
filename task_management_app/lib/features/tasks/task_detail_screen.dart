import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/mock_data/mock_data.dart';
import '../../shared/models/task_model.dart';

/// Task detail screen showing full task info, comments, and attachments.
class TaskDetailScreen extends StatelessWidget {
  final String taskId;

  const TaskDetailScreen({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final task = MockData.tasks.firstWhere(
      (t) => t.id == taskId,
      orElse: () => MockData.tasks.first,
    );
    final priorityColor = _getPriorityColor(task.priority);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.edit_2, size: 22),
            onPressed: () => context.push('/edit-task/${task.id}'),
          ),
          IconButton(
            icon: const Icon(Iconsax.more, size: 22),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Priority & Status ──────────────────────────────
            Row(
              children: [
                _Badge(
                  label: TaskModel.priorityLabel(task.priority),
                  color: priorityColor,
                ),
                const SizedBox(width: 8),
                _Badge(
                  label: TaskModel.statusLabel(task.status),
                  color: _getStatusColor(task.status),
                ),
                const SizedBox(width: 8),
                _Badge(
                  label: TaskModel.categoryLabel(task.category),
                  color: theme.colorScheme.primary,
                ),
              ],
            ).animate().fadeIn(),

            const SizedBox(height: 20),

            // ── Title ──────────────────────────────────────────
            Text(
              task.title,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.05),

            const SizedBox(height: 12),

            // ── Description ────────────────────────────────────
            Text(
              task.description,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
                height: 1.6,
              ),
            ).animate().fadeIn(delay: 200.ms),

            const SizedBox(height: 24),

            // ── Progress & Info Cards ──────────────────────────
            Row(
              children: [
                // Progress circle
                Expanded(
                  child: _InfoCard(
                    theme: theme,
                    child: Row(
                      children: [
                        CircularPercentIndicator(
                          radius: 28,
                          lineWidth: 5,
                          percent: task.progress.clamp(0.0, 1.0),
                          center: Text(
                            '${(task.progress * 100).toInt()}%',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          progressColor: theme.colorScheme.primary,
                          backgroundColor:
                              theme.colorScheme.primary.withOpacity(0.1),
                          circularStrokeCap: CircularStrokeCap.round,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Progress',
                                style:
                                    theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.4),
                                ),
                              ),
                              Text(
                                TaskModel.statusLabel(task.status),
                                style:
                                    theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Due date
                Expanded(
                  child: _InfoCard(
                    theme: theme,
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: _getDueDateColor(task).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Iconsax.calendar_1,
                            size: 20,
                            color: _getDueDateColor(task),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Due Date',
                                style:
                                    theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.4),
                                ),
                              ),
                              Text(
                                DateFormat('MMM d, yyyy')
                                    .format(task.dueDate),
                                style:
                                    theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1),

            const SizedBox(height: 24),

            // ── Assignee ───────────────────────────────────────
            _InfoCard(
              theme: theme,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor:
                        theme.colorScheme.primary.withOpacity(0.1),
                    child: Text(
                      task.assigneeName[0],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Assignee',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.4),
                        ),
                      ),
                      Text(
                        task.assigneeName,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 400.ms),

            // ── Tags ───────────────────────────────────────────
            if (task.tags.isNotEmpty) ...[
              const SizedBox(height: 24),
              Text(
                'Tags',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: task.tags.map((tag) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '#$tag',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  );
                }).toList(),
              ).animate().fadeIn(delay: 500.ms),
            ],

            // ── Comments ───────────────────────────────────────
            if (task.comments.isNotEmpty) ...[
              const SizedBox(height: 24),
              Text(
                'Comments (${task.comments.length})',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              ...task.comments.asMap().entries.map((entry) {
                final comment = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _InfoCard(
                    theme: theme,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: theme.colorScheme.primary
                                  .withOpacity(0.1),
                              child: Text(
                                comment.userName[0],
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    comment.userName,
                                    style: theme.textTheme.titleSmall
                                        ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    _timeAgo(comment.createdAt),
                                    style: theme.textTheme.labelSmall
                                        ?.copyWith(
                                      color: theme.colorScheme.onSurface
                                          .withOpacity(0.4),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          comment.content,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface
                                .withOpacity(0.7),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(delay: (600 + entry.key * 100).ms);
              }),
            ],

            // ── Attachments ────────────────────────────────────
            if (task.attachments.isNotEmpty) ...[
              const SizedBox(height: 24),
              Text(
                'Attachments (${task.attachments.length})',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              ...task.attachments.map((att) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _InfoCard(
                    theme: theme,
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: _getFileColor(att.type).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            _getFileIcon(att.type),
                            size: 20,
                            color: _getFileColor(att.type),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                att.name,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                att.size,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.4),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.download_rounded,
                          size: 20,
                          color: theme.colorScheme.onSurface.withOpacity(0.3),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Color _getPriorityColor(TaskPriority p) {
    switch (p) {
      case TaskPriority.high:
        return AppColors.priorityHigh;
      case TaskPriority.medium:
        return AppColors.priorityMedium;
      case TaskPriority.low:
        return AppColors.priorityLow;
    }
  }

  Color _getStatusColor(TaskStatus s) {
    switch (s) {
      case TaskStatus.todo:
        return AppColors.info;
      case TaskStatus.inProgress:
        return AppColors.warning;
      case TaskStatus.completed:
        return AppColors.success;
      case TaskStatus.overdue:
        return AppColors.error;
    }
  }

  Color _getDueDateColor(TaskModel task) {
    if (task.status == TaskStatus.completed) return AppColors.success;
    if (task.dueDate.isBefore(DateTime.now())) return AppColors.error;
    if (task.dueDate.difference(DateTime.now()).inDays <= 2) {
      return AppColors.warning;
    }
    return AppColors.info;
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  IconData _getFileIcon(String type) {
    switch (type) {
      case 'pdf':
        return Icons.picture_as_pdf_rounded;
      case 'image':
        return Icons.image_rounded;
      case 'figma':
        return Icons.design_services_rounded;
      case 'json':
        return Icons.data_object_rounded;
      default:
        return Icons.insert_drive_file_rounded;
    }
  }

  Color _getFileColor(String type) {
    switch (type) {
      case 'pdf':
        return AppColors.error;
      case 'image':
        return AppColors.success;
      case 'figma':
        return const Color(0xFFA259FF);
      case 'json':
        return AppColors.warning;
      default:
        return AppColors.info;
    }
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;

  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final ThemeData theme;
  final Widget child;

  const _InfoCard({required this.theme, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.06)
              : Colors.black.withOpacity(0.04),
        ),
      ),
      child: child,
    );
  }
}
