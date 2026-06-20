import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';
import '../../shared/models/task_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'repositories/task_repository.dart';
import 'providers/task_providers.dart';

/// Screen for creating a new task with form fields.
class CreateTaskScreen extends ConsumerStatefulWidget {
  const CreateTaskScreen({super.key});

  @override
  ConsumerState<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends ConsumerState<CreateTaskScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  TaskPriority _priority = TaskPriority.medium;
  TaskCategory _category = TaskCategory.development;
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _createTask() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter a task title'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final repo = ref.read(taskRepositoryProvider);
      await repo.createTask(
        _titleController.text.trim(),
        _descriptionController.text.trim(),
        false // status: false meaning not completed
      );

      setState(() => _isLoading = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Task created successfully! ✨'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.success,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
        // Refresh tasks
        ref.invalidate(tasksProvider);
        context.pop();
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create task: ${e.toString()}'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.error,
          ),
        );
      }
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
        title: const Text('Create Task'),
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
            ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.05),

            const SizedBox(height: AppConstants.spacingLg),

            // Description
            AppTextField(
              label: 'Description',
              hintText: 'Enter task description',
              controller: _descriptionController,
              prefixIcon: Iconsax.document_text,
              maxLines: 4,
              textInputAction: TextInputAction.newline,
            ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.05),

            const SizedBox(height: AppConstants.spacingXxl),

            // Priority
            Text(
              'Priority',
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ).animate().fadeIn(delay: 300.ms),
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
                              fontWeight:
                                  isSelected ? FontWeight.w600 : FontWeight.w400,
                              color: isSelected
                                  ? color
                                  : theme.colorScheme.onSurface.withOpacity(0.5),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ).animate().fadeIn(delay: 350.ms),

            const SizedBox(height: AppConstants.spacingXxl),

            // Category
            Text(
              'Category',
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ).animate().fadeIn(delay: 400.ms),
            const SizedBox(height: AppConstants.spacingSm),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: TaskCategory.values.map((c) {
                final isSelected = c == _category;
                return GestureDetector(
                  onTap: () => setState(() => _category = c),
                  child: AnimatedContainer(
                    duration: AppConstants.animFast,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? theme.colorScheme.primary.withOpacity(0.15)
                          : theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? theme.colorScheme.primary.withOpacity(0.5)
                            : theme.colorScheme.outline.withOpacity(0.2),
                      ),
                    ),
                    child: Text(
                      TaskModel.categoryLabel(c),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                        color: isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface.withOpacity(0.5),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ).animate().fadeIn(delay: 450.ms),

            const SizedBox(height: AppConstants.spacing4xl),

            // Create button
            AppButton(
              label: 'Create Task',
              variant: AppButtonVariant.gradient,
              isLoading: _isLoading,
              onPressed: _createTask,
              icon: Iconsax.add_circle,
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
