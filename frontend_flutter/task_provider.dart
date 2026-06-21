import 'package:flutter/material.dart';
import 'package:task_management_app/models/task_model.dart';
import 'package:task_management_app/services/api_service.dart';

class TaskProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Task> _tasks = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _filterStatus = 'all'; // all, completed, pending
  String _sortBy = 'date'; // date, priority, name

  // Getters
  List<Task> get tasks => _getFilteredAndSortedTasks();
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get filterStatus => _filterStatus;
  String get sortBy => _sortBy;

  // Stats getters
  int get totalTasks => _tasks.length;
  int get completedTasks => _tasks.where((task) => task.isCompleted).length;
  int get pendingTasks => _tasks.where((task) => !task.isCompleted).length;

  // Initialize - fetch all tasks
  Future<void> loadTasks() async {
    _setLoading(true);
    _clearError();

    try {
      _tasks = await _apiService.getTasks();
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Create task
  Future<void> createTask(Task task) async {
    _setLoading(true);
    _clearError();

    try {
      final newTask = await _apiService.createTask(task);
      _tasks.add(newTask);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // Update task
  Future<void> updateTask(int id, Task task) async {
    _setLoading(true);
    _clearError();

    try {
      final updatedTask = await _apiService.updateTask(id, task);
      final index = _tasks.indexWhere((t) => t.id == id);
      if (index != -1) {
        _tasks[index] = updatedTask;
        notifyListeners();
      }
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // Delete task
  Future<void> deleteTask(int id) async {
    _setLoading(true);
    _clearError();

    try {
      await _apiService.deleteTask(id);
      _tasks.removeWhere((task) => task.id == id);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // Toggle task completion
  Future<void> toggleTaskStatus(int id, bool isCompleted) async {
    try {
      final updatedTask = await _apiService.toggleTaskStatus(id, !isCompleted);
      final index = _tasks.indexWhere((t) => t.id == id);
      if (index != -1) {
        _tasks[index] = updatedTask;
        notifyListeners();
      }
    } catch (e) {
      _setError(e.toString());
      rethrow;
    }
  }

  // Set filter
  void setFilterStatus(String status) {
    _filterStatus = status;
    notifyListeners();
  }

  // Set sort
  void setSortBy(String sort) {
    _sortBy = sort;
    notifyListeners();
  }

  // Helper methods
  List<Task> _getFilteredAndSortedTasks() {
    // Apply filter
    List<Task> filtered = _tasks;
    if (_filterStatus == 'completed') {
      filtered = _tasks.where((task) => task.isCompleted).toList();
    } else if (_filterStatus == 'pending') {
      filtered = _tasks.where((task) => !task.isCompleted).toList();
    }

    // Apply sort
    switch (_sortBy) {
      case 'priority':
        filtered.sort((a, b) {
          const priorityOrder = {'high': 0, 'medium': 1, 'low': 2};
          return (priorityOrder[a.priority] ?? 3)
              .compareTo(priorityOrder[b.priority] ?? 3);
        });
        break;
      case 'name':
        filtered.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'date':
      default:
        filtered.sort((a, b) {
          if (a.dueDate == null && b.dueDate == null) return 0;
          if (a.dueDate == null) return 1;
          if (b.dueDate == null) return -1;
          return a.dueDate!.compareTo(b.dueDate!);
        });
        break;
    }

    return filtered;
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  void clearError() {
    _clearError();
    notifyListeners();
  }
}
