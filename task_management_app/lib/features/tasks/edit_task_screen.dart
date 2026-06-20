import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';
import '../../shared/mock_data/mock_data.dart';
import '../../shared/models/task_model.dart';

/// Screen for editing an existing task.
class EditTaskScreen extends StatefulWidget {
  final String taskId;

  const EditTaskScreen({super.key, required this.taskId});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TaskPriority _priority;
  late TaskCategory _category;
  late bool _isCompleted;
  bool _isLoading = false;
  late TaskModel _task;

  @override
  void initState() {
    super.initState();
    _task = MockData.tasks.firstWhere(
      (t) => t.id == widget.taskId,
      orElse: () => MockData.tasks.first,
    );
    _titleController = TextEditingController(text: _task.title);
    _descriptionController = TextEditingController(text: _task.description);
    _priority = _task.priority;
    _category = _task.category;
    _isCompleted = _task.status == TaskStatus.completed;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveTask() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Task title cannot be empty'),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    // TODO: Replace with actual API call
    await Future.delayed(const Duration(milliseconds: 800));

    setState(() => _isLoading = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Task updated successfully! ✅'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.success,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
        title: const Text('Edit Task'),
        actions: [
          IconButton(
            icon: Icon(
              Iconsax.trash,
              color: AppColors.error,
              size: 22,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Delete Task'),
                  content: const Text(
                      'Are you sure you want to delete this task? This action cannot be undone.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        context.pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Task deleted'),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: AppColors.error,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      },
                      child: Text(
                        'Delete',
                        style: TextStyle(color: AppColors.error),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            AppTextField(
              label: 'Task Title',
              hintText: 'Enter task title',
              controller: _titleController,
              prefixIcon: Iconsax.task_square,
              textInputAction: TextInputAction.next,
            ).animate().fadeIn(delay: 100.ms),

            const SizedBox(height: AppConstants.spacingLg),

            // Description
            AppTextField(
              label: 'Description',
              hintText: 'Enter task description',
              controller: _descriptionController,
              prefixIcon: Iconsax.document_text,
              maxLines: 4,
            ).animate().fadeIn(delay: 200.ms),

            const SizedBox(height: AppConstants.spacingXxl),

            // Status toggle
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                border: Border.all(
                  color: theme.colorScheme.outline.withOpacity(0.15),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _isCompleted
                        ? Iconsax.tick_circle5
                        : Iconsax.clock,
                    color: _isCompleted ? AppColors.success : AppColors.warning,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mark as Completed',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          _isCompleted ? 'Task is done' : 'Task is pending',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _isCompleted,
                    onChanged: (v) => setState(() => _isCompleted = v),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 300.ms),

            const SizedBox(height: AppConstants.spacingXxl),

            // Priority
            Text(
              'Priority',
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppConstants.spacingSm),
            Row(
              children: TaskPriority.values.map((p) {
                final isSelected = p == _priority;
                final color = _getPriorityColor(p);
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: p != TaskPriority.low ? 8 : 0,
                    ),
                    child: GestureDetector(
                      onTap: () => setState(() => _priority = p),
                      child: AnimatedContainer(
                        duration: AppConstants.animFast,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? color.withOpacity(0.15)
                              : theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? color.withOpacity(0.5)
                                : theme.colorScheme.outline.withOpacity(0.2),
                            width: isSelected ? 1.5 : 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            TaskModel.priorityLabel(p),
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              color: isSelected
                                  ? color
                                  : theme.colorScheme.onSurface
                                      .withOpacity(0.5),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ).animate().fadeIn(delay: 400.ms),

            const SizedBox(height: AppConstants.spacing4xl),

            // Save button
            AppButton(
              label: 'Save Changes',
              variant: AppButtonVariant.gradient,
              isLoading: _isLoading,
              onPressed: _saveTask,
              icon: Iconsax.tick_circle,
            ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2),

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
}
