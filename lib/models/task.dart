import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 1)
class Task extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  DateTime date;

  @HiveField(3)
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.date,
    this.isCompleted = false,
  });
}