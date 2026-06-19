/// Priority levels for tasks.
enum TaskPriority { high, medium, low }

/// Status states for tasks.
enum TaskStatus { todo, inProgress, completed, overdue }

/// Category types for tasks.
enum TaskCategory { design, development, marketing, research, management, personal }

/// Comment model for task discussions.
class TaskComment {
  final String id;
  final String userName;
  final String avatarUrl;
  final String content;
  final DateTime createdAt;

  const TaskComment({
    required this.id,
    required this.userName,
    required this.avatarUrl,
    required this.content,
    required this.createdAt,
  });
}

/// Attachment model for task files.
class TaskAttachment {
  final String id;
  final String name;
  final String type; // pdf, image, doc, etc.
  final String size;

  const TaskAttachment({
    required this.id,
    required this.name,
    required this.type,
    required this.size,
  });
}

/// Task model representing a single task in the app.
class TaskModel {
  final String id;
  final String title;
  final String description;
  final TaskCategory category;
  final TaskPriority priority;
  final TaskStatus status;
  final DateTime dueDate;
  final DateTime createdAt;
  final double progress;
  final String assigneeName;
  final String assigneeAvatar;
  final List<TaskComment> comments;
  final List<TaskAttachment> attachments;
  final List<String> tags;

  const TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
    required this.status,
    required this.dueDate,
    required this.createdAt,
    required this.progress,
    required this.assigneeName,
    required this.assigneeAvatar,
    this.comments = const [],
    this.attachments = const [],
    this.tags = const [],
  });

  /// Returns the display color for the priority level.
  static String priorityLabel(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return 'High';
      case TaskPriority.medium:
        return 'Medium';
      case TaskPriority.low:
        return 'Low';
    }
  }

  /// Returns the display label for the status.
  static String statusLabel(TaskStatus status) {
    switch (status) {
      case TaskStatus.todo:
        return 'To Do';
      case TaskStatus.inProgress:
        return 'In Progress';
      case TaskStatus.completed:
        return 'Completed';
      case TaskStatus.overdue:
        return 'Overdue';
    }
  }

  /// Returns the display label for the category.
  static String categoryLabel(TaskCategory category) {
    switch (category) {
      case TaskCategory.design:
        return 'Design';
      case TaskCategory.development:
        return 'Development';
      case TaskCategory.marketing:
        return 'Marketing';
      case TaskCategory.research:
        return 'Research';
      case TaskCategory.management:
        return 'Management';
      case TaskCategory.personal:
        return 'Personal';
    }
  }
}
