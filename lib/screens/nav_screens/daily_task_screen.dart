import 'package:daily_diary_app/models/task.dart';
import 'package:daily_diary_app/providers/task_provider.dart';
import 'package:daily_diary_app/widgets/task_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DailyTasksScreen extends StatelessWidget {
  const DailyTasksScreen({Key? key}) : super(key: key);

  Map<DateTime, List<Task>> groupTasksByDate(List<Task> tasks) {
    Map<DateTime, List<Task>> grouped = {};

    for (var task in tasks) {
      final date = DateTime(task.date.year, task.date.month, task.date.day);

      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(task);
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final taskProvider = Provider.of<TaskProvider>(context);
    final allTasks = taskProvider.tasks;

    final groupedTasks = groupTasksByDate(allTasks);

    final sortedDates = groupedTasks.keys.toList()
      ..sort((a, b) => b.compareTo(a)); 

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Daily Tasks'),
      ),
      body: allTasks.isEmpty
          ? Center(
              child: Text(
                'No tasks available',
                style: theme.textTheme.bodyLarge,
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: sortedDates.length,
              itemBuilder: (context, index) {
                final date = sortedDates[index];
                final tasks = groupedTasks[date]!;

                final completedCount =
                    tasks.where((t) => t.isCompleted).length;

                final isAllDone = completedCount == tasks.length;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat('EEEE, MMM d').format(date),
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,fontSize: 14
                          ),
                        ),
                        if (isAllDone)
                          const Icon(Icons.check_circle,
                              color: Colors.green),
                      ],
                    ),

                    const SizedBox(height: 8),

                    
                    ...tasks.map((task) {
                      return TaskItem(
                        task: task,
                        onToggle: () {
                          taskProvider.toggleTask(task);
                        },
                        onDelete: () {
                          taskProvider.deleteTask(task);
                        },
                      );
                    }).toList(),

                    const SizedBox(height: 20),
                  ],
                );
              },
            ),
    );
  }
}