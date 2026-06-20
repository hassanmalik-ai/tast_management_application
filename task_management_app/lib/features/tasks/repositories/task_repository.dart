import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';
import '../../../shared/models/task_model.dart';

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final dio = ref.watch(apiClientProvider);
  return TaskRepository(dio: dio);
});

class TaskRepository {
  final Dio _dio;

  TaskRepository({required Dio dio}) : _dio = dio;

  Future<List<TaskModel>> getTasks() async {
    try {
      final response = await _dio.get('/tasks/get-all');
      final data = response.data as List;
      
      return data.map((json) => _mapBackendToTaskModel(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch tasks: ${e.toString()}');
    }
  }

  Future<TaskModel> getTask(int id) async {
    try {
      final response = await _dio.get('/tasks/get-one/$id');
      return _mapBackendToTaskModel(response.data);
    } catch (e) {
      throw Exception('Failed to fetch task: ${e.toString()}');
    }
  }

  Future<TaskModel> createTask(String title, String description, bool status) async {
    try {
      final response = await _dio.post('/tasks/create', data: {
        'title': title,
        'description': description,
        'status': status,
      });
      return _mapBackendToTaskModel(response.data);
    } catch (e) {
      throw Exception('Failed to create task: ${e.toString()}');
    }
  }

  Future<TaskModel> updateTask(int id, String title, String description, bool status) async {
    try {
      final response = await _dio.put('/tasks/update/$id', data: {
        'title': title,
        'description': description,
        'status': status,
      });
      return _mapBackendToTaskModel(response.data);
    } catch (e) {
      throw Exception('Failed to update task: ${e.toString()}');
    }
  }

  Future<void> deleteTask(int id) async {
    try {
      await _dio.delete('/tasks/delete/$id');
    } catch (e) {
      throw Exception('Failed to delete task: ${e.toString()}');
    }
  }

  TaskModel _mapBackendToTaskModel(Map<String, dynamic> json) {
    final bool statusBool = json['status'] ?? false;
    final status = statusBool ? TaskStatus.completed : TaskStatus.todo;

    return TaskModel(
      id: (json['id'] ?? 0).toString(),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: TaskCategory.personal, // Default as backend doesn't support
      priority: TaskPriority.medium,   // Default
      status: status,
      dueDate: DateTime.now().add(const Duration(days: 7)), // Default
      createdAt: DateTime.now(),
      progress: statusBool ? 1.0 : 0.0,
      assigneeName: 'User',
      assigneeAvatar: 'https://i.pravatar.cc/300',
    );
  }
}
