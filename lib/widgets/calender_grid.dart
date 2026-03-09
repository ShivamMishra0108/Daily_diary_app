import 'package:daily_diary_app/providers/plan_provider.dart';
import 'package:daily_diary_app/providers/task_provider.dart';
import 'package:daily_diary_app/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CalendarGrid extends StatelessWidget {

  final DateTime currentDate;
  final DateTime? selectedDate;
  final Function(DateTime) onDateSelected;

  const CalendarGrid({
    Key? key,
    required this.currentDate,
    required this.selectedDate,
    required this.onDateSelected,
  }) : super(key: key);

  List<DateTime> _getDaysInMonth(DateTime date) {
    final firstDay = DateTime(date.year, date.month, 1);
    final lastDay = DateTime(date.year, date.month + 1, 0);

    final startOffset = firstDay.weekday % 7;
    final startDate = firstDay.subtract(Duration(days: startOffset));

    final endOffset = 6 - (lastDay.weekday % 7);
    final endDate = lastDay.add(Duration(days: endOffset));

    List<DateTime> days = [];

    for (var day = startDate;
        day.isBefore(endDate.add(const Duration(days: 1)));
        day = day.add(const Duration(days: 1))) {
      days.add(day);
    }

    return days;
  }

  bool _isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) return false;

    return a.year == b.year &&
        a.month == b.month &&
        a.day == b.day;
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return _isSameDay(date, now);
  }

  bool _isCurrentMonth(DateTime date) {
    return date.month == currentDate.month &&
        date.year == currentDate.year;
  }

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    final taskProvider = Provider.of<TaskProvider>(context);
    final planProvider = Provider.of<PlanProvider>(context);

    final days = _getDaysInMonth(currentDate);

    final weekDays = ['Sun','Mon','Tue','Wed','Thu','Fri','Sat'];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [

          /// Week headers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: weekDays.map((day) {
              return Expanded(
                child: Center(
                  child: Text(
                    day,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 16),

          /// Calendar Grid
          Expanded(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),

              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),

              itemCount: days.length,

              itemBuilder: (context, index) {

                final day = days[index];

                final isCurrentMonth = _isCurrentMonth(day);
                final isToday = _isToday(day);
                final isSelected = _isSameDay(day, selectedDate);

                final hasTasks = taskProvider.hasTasksForDate(day);
                final isCompleted = taskProvider.isDateCompleted(day);

                final hasPlan = planProvider.isDateInPlan(day);

                Color? backgroundColor;
                Color? borderColor;
                Color? textColor;

                /// Selected
                if (isSelected) {
                  backgroundColor = theme.primaryColor;
                  textColor = Colors.white;
                }

                /// Plan day
                else if (hasPlan) {
                  backgroundColor = Colors.yellowAccent.withOpacity(0.4);
                  textColor = Colors.black;
                }

                /// Today
                else if (isToday) {
                  borderColor = theme.primaryColor;
                  textColor = theme.primaryColor;
                }

                /// Completed tasks
                else if (hasTasks && isCompleted) {
                  backgroundColor =
                      AppTheme.completedGreen.withOpacity(0.25);
                  textColor = AppTheme.completedGreen;
                }

                /// Default
                else {
                  textColor = isCurrentMonth
                      ? theme.textTheme.bodyLarge?.color
                      : theme.disabledColor;
                }

                return InkWell(
                  onTap: () => onDateSelected(day),

                  borderRadius: BorderRadius.circular(12),

                  child: Container(
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(12),
                      border: borderColor != null
                          ? Border.all(color: borderColor, width: 2)
                          : null,
                    ),

                    child: Stack(
                      children: [

                        /// Day number
                        Center(
                          child: Text(
                            DateFormat('d').format(day),
                            style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),

                        /// Pending task indicator
                        if (hasTasks && !isCompleted)
                          Positioned(
                            bottom: 4,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Container(
                                width: 5,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: Colors.orange,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
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
    );
  }
}