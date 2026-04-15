import 'package:hive/hive.dart';

part 'plan.g.dart';

@HiveType(typeId: 0)
class Plan extends HiveObject {

  @HiveField(0)
  String name;

  @HiveField(1)
  DateTime startDate;

  @HiveField(2)
  DateTime endDate;

  @HiveField(3, defaultValue: 0) // ✅ THIS FIXES CRASH
  int days;

  Plan({
    required this.name,
    required this.startDate,
    required this.endDate,
    this.days = 0, // ✅ default value here also
  });
}