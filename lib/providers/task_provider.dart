import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/task.dart';

class TaskProvider with ChangeNotifier {

  final Box<Task> _taskBox = Hive.box<Task>('tasksBox');

  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  TaskProvider() {
    loadTasks();
  }

  /// LOAD ALL TASKS
  void loadTasks() {
    _tasks = _taskBox.values.toList();
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    await _taskBox.add(task);
    loadTasks();
  }

  Future<void> updateTask(Task task) async {
    await task.save();
    loadTasks();
  }

  Future<void> deleteTask(Task task) async {
    await task.delete();
    loadTasks();
  }

  Future<void> toggleTask(Task task) async {
    task.isCompleted = !task.isCompleted;
    await task.save();
    loadTasks();
  }

  List<Task> getTasksForDate(DateTime date) {
    return _tasks.where((task) {
      final d = task.date;
      return d.year == date.year &&
          d.month == date.month &&
          d.day == date.day;
    }).toList();
  }

  bool hasTasksForDate(DateTime date) {
    return getTasksForDate(date).isNotEmpty;
  }

  bool isDateCompleted(DateTime date) {
    final tasks = getTasksForDate(date);
    if (tasks.isEmpty) return false;
    return tasks.every((t) => t.isCompleted);
  }

  int taskCountForDate(DateTime date) {
    return getTasksForDate(date).length;
  }

  int completedTaskCountForDate(DateTime date) {
    return getTasksForDate(date)
        .where((t) => t.isCompleted)
        .length;
  }
}