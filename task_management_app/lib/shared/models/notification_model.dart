/// Type of notification.
enum NotificationType { taskAssigned, taskCompleted, reminder, comment, mention }

/// Notification model for the notifications screen.
class NotificationModel {
  final String id;
  final String title;
  final String message;
  final DateTime createdAt;
  final bool isRead;
  final NotificationType type;
  final String? relatedTaskId;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.createdAt,
    required this.isRead,
    required this.type,
    this.relatedTaskId,
  });
}
