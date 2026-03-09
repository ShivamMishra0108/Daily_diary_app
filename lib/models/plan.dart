
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

  Plan({
    required this.name,
    required this.startDate,
    required this.endDate,
  });
}

