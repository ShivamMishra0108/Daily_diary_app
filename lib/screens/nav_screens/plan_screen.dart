import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Plan {
  final String name;
  final DateTime start;
  final DateTime end;
  final int days;

  Plan({
    required this.name,
    required this.start,
    required this.end,
    required this.days,
  });
}

class PlanScreen extends StatefulWidget {
  const PlanScreen({super.key});

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  final TextEditingController _planController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;

  final List<Plan> _plans = [];

  final DateFormat _dateFormat = DateFormat('dd MMM yyyy');

  int get _totalDays {
    final start = _startDate;
    final end = _endDate;

    if (start == null || end == null) return 0;

    return end.difference(start).inDays + 1;
  }

  Future<void> _pickDate({required bool isStart}) async {
    DateTime initialDate = isStart
        ? (_startDate ?? DateTime.now())
        : (_endDate ?? (_startDate ?? DateTime.now()).add(const Duration(days: 1)));

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        if (isStart) {
          _startDate = pickedDate;

          if (_endDate != null && _endDate!.isBefore(_startDate!)) {
            _endDate = null;
          }
        } else {
          _endDate = pickedDate;
        }
      });
    }
  }

  void _savePlan() {
    if (_planController.text.isNotEmpty &&
        _startDate != null &&
        _endDate != null) {
      setState(() {
        _plans.add(
          Plan(
            name: _planController.text,
            start: _startDate!,
            end: _endDate!,
            days: _totalDays,
          ),
        );

        _planController.clear();
        _startDate = null;
        _endDate = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter plan and select dates")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Plan"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Plan Name
            TextField(
              controller: _planController,
              decoration: const InputDecoration(
                labelText: "Enter your plan",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            /// Start Date
            Row(
              children: [
                Text(
                  _startDate == null
                      ? "No start date"
                      : "Start: ${_dateFormat.format(_startDate!)}",
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () => _pickDate(isStart: true),
                  child: const Text("Start Date"),
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// End Date
            Row(
              children: [
                Text(
                  _endDate == null
                      ? "No end date"
                      : "End: ${_dateFormat.format(_endDate!)}",
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed:
                      _startDate == null ? null : () => _pickDate(isStart: false),
                  child: const Text("End Date"),
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// Total Days
            if (_startDate != null && _endDate != null)
              Text(
                "Total Days: $_totalDays",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),

            const SizedBox(height: 16),

            /// Save Button
            ElevatedButton(
              onPressed: _savePlan,
              child: const Text("Save Plan"),
            ),

            const SizedBox(height: 20),

            /// Plan List
            Expanded(
              child: _plans.isEmpty
                  ? const Center(child: Text("No Plans Yet"))
                  : ListView.builder(
                      itemCount: _plans.length,
                      itemBuilder: (context, index) {
                        final plan = _plans[index];

                        return Card(
                          child: ListTile(
                            title: Text(plan.name),
                            subtitle: Text(
                              "${_dateFormat.format(plan.start)} - ${_dateFormat.format(plan.end)}",
                            ),
                            trailing: Text("${plan.days} days"),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
