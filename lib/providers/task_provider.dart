import 'package:daily_diary_app/services/notification_services.dart';
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

  void loadTasks() {
    _tasks = _taskBox.values.toList();
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    await _taskBox.add(task);
    loadTasks();
    checkPendingTasksAndNotify();
  }

  Future<void> updateTask(Task task) async {
    await task.save();
    loadTasks();
    checkPendingTasksAndNotify(); 
  }

  Future<void> deleteTask(Task task) async {
    await task.delete();
    loadTasks();
    checkPendingTasksAndNotify(); 
  }

  Future<void> toggleTask(Task task) async {
    task.isCompleted = !task.isCompleted;
    await task.save();
    loadTasks();
    checkPendingTasksAndNotify(); 
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

  void checkPendingTasksAndNotify() {
    final today = DateTime.now();

    final todayTasks = getTasksForDate(today);

    final pendingTasks =
        todayTasks.where((t) => !t.isCompleted).length;

    if (pendingTasks > 0) {
      NotificationService.showNotification(
        title: "Pending Tasks ",
        body: "You have $pendingTasks tasks pending today",
      );
    }
  }
}