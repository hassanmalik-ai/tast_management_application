import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/models/task_model.dart';
import '../repositories/task_repository.dart';

final tasksProvider = FutureProvider.autoDispose<List<TaskModel>>((ref) async {
  final repository = ref.watch(taskRepositoryProvider);
  return repository.getTasks();
});

final taskDetailProvider = FutureProvider.family.autoDispose<TaskModel, int>((ref, id) async {
  final repository = ref.watch(taskRepositoryProvider);
  return repository.getTask(id);
});
