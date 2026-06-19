/// User model representing an app user.
class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String avatarUrl;
  final String role;
  final DateTime joinedAt;
  final int tasksCompleted;
  final int tasksInProgress;
  final int streakDays;

  const UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.avatarUrl,
    required this.role,
    required this.joinedAt,
    this.tasksCompleted = 0,
    this.tasksInProgress = 0,
    this.streakDays = 0,
  });
}
