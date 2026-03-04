import 'package:daily_diary_app/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';

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
    final firstDayOfMonth = DateTime(date.year, date.month, 1);
    final lastDayOfMonth = DateTime(date.year, date.month + 1, 0);
    
    final firstWeekday = firstDayOfMonth.weekday % 7;
    final startDate = firstDayOfMonth.subtract(Duration(days: firstWeekday));
    
    final lastWeekday = lastDayOfMonth.weekday % 7;
    final endDate = lastDayOfMonth.add(Duration(days: 6 - lastWeekday));
    
    final days = <DateTime>[];
    for (var day = startDate;
        day.isBefore(endDate.add(const Duration(days: 1)));
        day = day.add(const Duration(days: 1))) {
      days.add(day);
    }
    
    return days;
  }

  bool _isSameDay(DateTime? date1, DateTime? date2) {
    if (date1 == null || date2 == null) return false;
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return _isSameDay(date, now);
  }

  bool _isCurrentMonth(DateTime date) {
    return date.month == currentDate.month && date.year == currentDate.year;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final taskProvider = Provider.of<TaskProvider>(context);
    final days = _getDaysInMonth(currentDate);
    final weekDays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Week day headers
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

          // Calendar days grid
          Expanded(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                final hasCompletedTasks = taskProvider.isDateCompleted(day);
                final hasTasks = taskProvider.hasTasksForDate(day);

                // Determine the color based on task completion
                Color? backgroundColor;
                Color? borderColor;
                Color? textColor;

                if (isSelected) {
                  backgroundColor = hasCompletedTasks && hasTasks
                      ? AppTheme.completedGreen
                      : theme.primaryColor;
                  textColor = Colors.white;
                } else if (isToday) {
                  backgroundColor = theme.colorScheme.surface;
                  borderColor = hasCompletedTasks && hasTasks
                      ? AppTheme.completedGreen
                      : theme.primaryColor;
                  textColor = hasCompletedTasks && hasTasks
                      ? AppTheme.completedGreen
                      : theme.primaryColor;
                } else if (hasCompletedTasks && hasTasks) {
                  backgroundColor = AppTheme.completedGreen.withOpacity(0.2);
                  textColor = AppTheme.completedGreen;
                } else {
                  textColor = isCurrentMonth
                      ? theme.textTheme.bodyLarge?.color
                      : theme.textTheme.bodyMedium?.color;
                }

                return TweenAnimationBuilder<double>(
                  duration: Duration(milliseconds: 200 + (index * 10)),
                  tween: Tween(begin: 0.0, end: 1.0),
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Opacity(
                        opacity: value,
                        child: child,
                      ),
                    );
                  },
                  child: InkWell(
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
                          Center(
                            child: Text(
                              DateFormat('d').format(day),
                              style: TextStyle(
                                color: textColor,
                                fontWeight: (isToday || isSelected || (hasCompletedTasks && hasTasks))
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          // Task indicator dot
                          if (hasTasks && !isSelected && !hasCompletedTasks)
                            Positioned(
                              bottom: 4,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: Container(
                                  width: 4,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: theme.primaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
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