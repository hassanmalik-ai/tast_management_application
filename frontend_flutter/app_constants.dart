/// Application-wide constants

class AppConstants {
  // App Info
  static const String appName = 'Task Manager';
  static const String appVersion = '1.0.0';

  // API Configuration
  // Change this to your FastAPI backend URL
  static const String apiBaseUrl = 'http://localhost:8000/api';
  
  // For different environments:
  // Development (Android Emulator): 'http://10.0.2.2:8000/api'
  // Development (iOS Simulator): 'http://localhost:8000/api'
  // Development (Physical Device): 'http://YOUR_MACHINE_IP:8000/api'
  // Production: 'https://your-api-domain.com/api'
  
  static const int apiTimeoutSeconds = 30;

  // Task Priorities
  static const String priorityLow = 'low';
  static const String priorityMedium = 'medium';
  static const String priorityHigh = 'high';

  static const List<String> priorities = [
    priorityLow,
    priorityMedium,
    priorityHigh,
  ];

  // Task Status
  static const String statusAll = 'all';
  static const String statusCompleted = 'completed';
  static const String statusPending = 'pending';

  // Sort Options
  static const String sortByDate = 'date';
  static const String sortByPriority = 'priority';
  static const String sortByName = 'name';

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 8.0;
  static const double defaultElevation = 1.0;

  // Animation Durations
  static const Duration shortDuration = Duration(milliseconds: 300);
  static const Duration mediumDuration = Duration(milliseconds: 500);
  static const Duration longDuration = Duration(milliseconds: 800);

  // Form Validation
  static const int minTaskTitleLength = 3;
  static const int maxTaskTitleLength = 200;
  static const int maxTaskDescriptionLength = 1000;

  // Error Messages
  static const String errorLoadingTasks = 'Failed to load tasks';
  static const String errorCreatingTask = 'Failed to create task';
  static const String errorUpdatingTask = 'Failed to update task';
  static const String errorDeletingTask = 'Failed to delete task';
  static const String errorNetworkConnection = 'Network connection error';
  static const String errorUnknown = 'An unknown error occurred';

  // Success Messages
  static const String successTaskCreated = 'Task created successfully';
  static const String successTaskUpdated = 'Task updated successfully';
  static const String successTaskDeleted = 'Task deleted successfully';
}

/// Priority colors
class PriorityColors {
  static const Map<String, int> colorMap = {
    'high': 0xFFEF5350,    // Red
    'medium': 0xFFFFA726,  // Orange
    'low': 0xFF66BB6A,     // Green
  };

  static int getColor(String priority) {
    return colorMap[priority] ?? 0xFF9E9E9E; // Gray as default
  }
}
