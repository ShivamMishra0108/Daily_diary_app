import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/plan.dart';

class PlanProvider with ChangeNotifier {

  late Box<Plan> _planBox;

  List<Plan> _plans = [];

  List<Plan> get plans => _plans;

  /// Initialize Hive data
  Future<void> init() async {
    _planBox = Hive.box<Plan>('plans');
    loadPlans();
  }

  /// Load all saved plans
  void loadPlans() {
    _plans = _planBox.values.toList();
    notifyListeners();
  }

  /// Add new plan
  void addPlan(String name, DateTime start, DateTime end) {
    final plan = Plan(
      name: name,
      startDate: start,
      endDate: end,
    );

    _planBox.add(plan);
    loadPlans();
  }

  /// Check if date is inside any plan
  bool isDateInPlan(DateTime date) {
    for (var plan in _plans) {
      if (!date.isBefore(plan.startDate) &&
          !date.isAfter(plan.endDate)) {
        return true;
      }
    }
    return false;
  }
}