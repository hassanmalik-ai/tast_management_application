import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:task_management_app/models/task_model.dart';

class ApiService {
  // Change this to your FastAPI server URL
  static const String baseUrl = 'http://localhost:8000/api';
  static const Duration timeout = Duration(seconds: 30);

  // Get all tasks
  Future<List<Task>> getTasks() async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/tasks'),
          )
          .timeout(timeout);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData.map((json) => Task.fromJson(json as Map<String, dynamic>)).toList();
      } else {
        throw Exception('Failed to load tasks: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching tasks: $e');
    }
  }

  // Get single task by ID
  Future<Task> getTaskById(int id) async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/tasks/$id'),
          )
          .timeout(timeout);

      if (response.statusCode == 200) {
        return Task.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        throw Exception('Failed to load task: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching task: $e');
    }
  }

  // Create new task
  Future<Task> createTask(Task task) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/tasks'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(task.toJson()),
          )
          .timeout(timeout);

      if (response.statusCode == 201 || response.statusCode == 200) {
        return Task.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        throw Exception('Failed to create task: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating task: $e');
    }
  }

  // Update task
  Future<Task> updateTask(int id, Task task) async {
    try {
      final response = await http
          .put(
            Uri.parse('$baseUrl/tasks/$id'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(task.toJson()),
          )
          .timeout(timeout);

      if (response.statusCode == 200) {
        return Task.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        throw Exception('Failed to update task: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating task: $e');
    }
  }

  // Delete task
  Future<void> deleteTask(int id) async {
    try {
      final response = await http
          .delete(
            Uri.parse('$baseUrl/tasks/$id'),
          )
          .timeout(timeout);

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete task: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting task: $e');
    }
  }

  // Toggle task completion status
  Future<Task> toggleTaskStatus(int id, bool isCompleted) async {
    try {
      final response = await http
          .patch(
            Uri.parse('$baseUrl/tasks/$id/toggle'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'is_completed': isCompleted}),
          )
          .timeout(timeout);

      if (response.statusCode == 200) {
        return Task.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        throw Exception('Failed to toggle task: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error toggling task: $e');
    }
  }
}
