import 'package:daily_diary_app/providers/plan_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PlanScreen extends StatefulWidget {
  const PlanScreen({super.key});

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  final TextEditingController _planController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;

  final DateFormat _dateFormat = DateFormat('dd MMM yyyy');

  int get _totalDays {
    if (_startDate == null || _endDate == null) return 0;
    return _endDate!.difference(_startDate!).inDays + 1;
  }

  Future<void> _pickDate({required bool isStart}) async {
    DateTime initialDate = isStart
        ? (_startDate ?? DateTime.now())
        : (_endDate ??
            (_startDate ?? DateTime.now()).add(const Duration(days: 1)));

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
    if (_planController.text.isEmpty ||
        _startDate == null ||
        _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter plan and select dates")),
      );
      return;
    }

    Provider.of<PlanProvider>(context, listen: false).addPlan(
      _planController.text,
      _startDate!,
      _endDate!,
    );

    setState(() {
      _planController.clear();
      _startDate = null;
      _endDate = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final plans = context.watch<PlanProvider>().plans;

    return Scaffold(
      appBar: AppBar(title: const Text("Plan")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            TextField(
              controller: _planController,
              decoration: const InputDecoration(
                labelText: "Enter your plan",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            /// START DATE
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

            /// END DATE
            Row(
              children: [
                Text(
                  _endDate == null
                      ? "No end date"
                      : "End: ${_dateFormat.format(_endDate!)}",
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: _startDate == null
                      ? null
                      : () => _pickDate(isStart: false),
                  child: const Text("End Date"),
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// TOTAL DAYS
            if (_startDate != null && _endDate != null)
              Text(
                "Total Days: $_totalDays",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: _savePlan,
              child: const Text("Save Plan"),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: plans.isEmpty
                  ? const Center(child: Text("No Plans Yet"))
                  : ListView.builder(
                      itemCount: plans.length,
                      itemBuilder: (context, index) {
                        final plan = plans[index];

                        return Card(
                          child: ListTile(
                            title: Text(plan.name),

                            subtitle: Text(
                              "${_dateFormat.format(plan.startDate)} - ${_dateFormat.format(plan.endDate)}",
                            ),

                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("${plan.days} days"),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    context
                                        .read<PlanProvider>()
                                        .deletePlan(plan);
                                  },
                                ),
                              ],
                            ),
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