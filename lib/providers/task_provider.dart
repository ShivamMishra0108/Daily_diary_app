import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> _tasks = [];
  static const String _storageKey = 'tasks';

  List<Task> get tasks => _tasks;

  List<Task> getTasksForDate(DateTime date) {
    return _tasks.where((task) {
      return task.date.year == date.year &&
          task.date.month == date.month &&
          task.date.day == date.day;
    }).toList();
  }

  bool isDateCompleted(DateTime date) {
    final dateTasks = getTasksForDate(date);
    if (dateTasks.isEmpty) return false;
    return dateTasks.every((task) => task.isCompleted);
  }

  bool hasTasksForDate(DateTime date) {
    return getTasksForDate(date).isNotEmpty;
  }

  Future<void> addTask(Task task) async {
    _tasks.add(task);
    notifyListeners();
    await _saveTasks();
  }

  Future<void> updateTask(Task task) async {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
      notifyListeners();
      await _saveTasks();
    }
  }

  Future<void> deleteTask(String taskId) async {
    _tasks.removeWhere((task) => task.id == taskId);
    notifyListeners();
    await _saveTasks();
  }

  Future<void> toggleTaskCompletion(String taskId) async {
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index != -1) {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
      notifyListeners();
      await _saveTasks();
    }
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = _tasks.map((task) => task.toJson()).toList();
    await prefs.setString(_storageKey, json.encode(tasksJson));
  }

  Future<void> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksString = prefs.getString(_storageKey);
    if (tasksString != null) {
      final List<dynamic> tasksJson = json.decode(tasksString);
      _tasks = tasksJson.map((json) => Task.fromJson(json)).toList();
      notifyListeners();
    }
  }
}