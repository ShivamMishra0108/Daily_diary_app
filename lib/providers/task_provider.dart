import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/task.dart';

class TaskProvider with ChangeNotifier {

  /// ✅ DIRECT BOX INIT (NO init() needed)
  final Box<Task> _taskBox = Hive.box<Task>('tasksBox');

  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  /// ✅ CONSTRUCTOR AUTO LOAD
  TaskProvider() {
    loadTasks();
  }

  /// LOAD ALL TASKS
  void loadTasks() {
    _tasks = _taskBox.values.toList();
    notifyListeners();
  }

  /// ADD TASK
  Future<void> addTask(Task task) async {
    await _taskBox.add(task);
    loadTasks();
  }

  /// UPDATE TASK
  Future<void> updateTask(Task task) async {
    await task.save();
    loadTasks();
  }

  /// DELETE TASK
  Future<void> deleteTask(Task task) async {
    await task.delete();
    loadTasks();
  }

  /// TOGGLE COMPLETION
  Future<void> toggleTask(Task task) async {
    task.isCompleted = !task.isCompleted;
    await task.save();
    loadTasks();
  }

  // ================================
  // 📅 CALENDAR FUNCTIONS
  // ================================

  /// GET TASKS FOR DATE
  List<Task> getTasksForDate(DateTime date) {
    return _tasks.where((task) {
      final d = task.date;
      return d.year == date.year &&
          d.month == date.month &&
          d.day == date.day;
    }).toList();
  }

  /// HAS TASKS
  bool hasTasksForDate(DateTime date) {
    return getTasksForDate(date).isNotEmpty;
  }

  /// ALL COMPLETED?
  bool isDateCompleted(DateTime date) {
    final tasks = getTasksForDate(date);
    if (tasks.isEmpty) return false;
    return tasks.every((t) => t.isCompleted);
  }

  /// COUNT
  int taskCountForDate(DateTime date) {
    return getTasksForDate(date).length;
  }

  /// COMPLETED COUNT
  int completedTaskCountForDate(DateTime date) {
    return getTasksForDate(date)
        .where((t) => t.isCompleted)
        .length;
  }
}