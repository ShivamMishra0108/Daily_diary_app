import 'package:hive/hive.dart';

part 'profile.g.dart';

@HiveType(typeId: 2)
class Profile extends HiveObject {

  @HiveField(0)
  String name;

  @HiveField(1)
  String goal;

  Profile({
    required this.name,
    required this.goal,
  });
}