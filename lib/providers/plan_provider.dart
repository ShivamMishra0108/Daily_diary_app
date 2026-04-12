import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/plan.dart';

class PlanProvider with ChangeNotifier {
  final Box<Plan> _planBox = Hive.box<Plan>('plansBox');

  List<Plan> _plans = [];

  List<Plan> get plans => _plans;

  PlanProvider() {
    loadPlans();
  }

  /// LOAD ALL PLANS
  void loadPlans() {
    _plans = _planBox.values.toList();
    notifyListeners();
  }

  /// ADD PLAN
  Future<void> addPlan(String name, DateTime start, DateTime end) async {
    final days = end.difference(start).inDays + 1;

    final plan = Plan(
      name: name,
      startDate: start,
      endDate: end,
      days: days,
    );

    await _planBox.add(plan);
    loadPlans();
  }

  // DELETE PLAN
  Future<void> deletePlan(Plan plan) async {
    await plan.delete();
    loadPlans();
  }

  bool isDateInPlan(DateTime date) {
    for (var plan in _plans) {
      if ((date.isAfter(plan.startDate) ||
              _isSameDay(date, plan.startDate)) &&
          (date.isBefore(plan.endDate) ||
              _isSameDay(date, plan.endDate))) {
        return true;
      }
    }
    return false;
  }

  // HELPER
  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year &&
        a.month == b.month &&
        a.day == b.day;
  }
}