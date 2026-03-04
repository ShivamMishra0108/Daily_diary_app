import 'package:flutter/material.dart';

class PlanScreen extends StatefulWidget {
  const PlanScreen({super.key});

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  final TextEditingController _planController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;

  int get _totalDays {
    if (_startDate != null && _endDate != null) {
      return _endDate!.difference(_startDate!).inDays + 1; // inclusive
    }
    return 0;
  }

  Future<void> _pickDate({required bool isStart}) async {
    DateTime initialDate = isStart
        ? (_startDate ?? DateTime.now())
        : (_endDate ?? (_startDate ?? DateTime.now()).add(Duration(days: 1)));
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
          // Reset end date if it's before start date
          if (_endDate != null && _endDate!.isBefore(_startDate!)) {
            _endDate = null;
          }
        } else {
          _endDate = pickedDate;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Plan")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _planController,
              decoration: InputDecoration(
                labelText: "Enter your plan",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Text(_startDate == null
                    ? "No start date"
                    : "Start: ${_startDate!.toLocal()}".split(' ')[0]),
                Spacer(),
                ElevatedButton(
                  onPressed: () => _pickDate(isStart: true),
                  child: Text("Pick Start Date"),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Text(_endDate == null
                    ? "No end date"
                    : "End: ${_endDate!.toLocal()}".split(' ')[0]),
                Spacer(),
                ElevatedButton(
                  onPressed: _startDate == null
                      ? null
                      : () => _pickDate(isStart: false),
                  child: Text("Pick End Date"),
                ),
              ],
            ),
            SizedBox(height: 16),
            if (_startDate != null && _endDate != null)
              Text("Total Days: $_totalDays",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green)),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_planController.text.isNotEmpty &&
                    _startDate != null &&
                    _endDate != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Plan Saved! Total $_totalDays days.")),
                  );
                  _planController.clear();
                  setState(() {
                    _startDate = null;
                    _endDate = null;
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Enter plan and select dates")),
                  );
                }
              },
              child: Text("Save Plan"),
            ),
          ],
        ),
      ),
    );
  }
}