import 'package:daily_diary_app/screens/Inner_screens/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/task_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  /// 🔥 Calculate streak (consecutive completed days)
  int calculateStreak(TaskProvider provider) {
    int streak = 0;
    DateTime current = DateTime.now();

    while (true) {
      if (provider.isDateCompleted(current)) {
        streak++;
        current = current.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }
    return streak;
  }

  /// 📊 Active days
  int activeDays(TaskProvider provider) {
    final dates = provider.tasks
        .map((t) => DateTime(t.date.year, t.date.month, t.date.day))
        .toSet();
    return dates.length;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = context.watch<TaskProvider>();

   final totalTasks = provider.tasks.length;
final completedTasks =
    provider.tasks.where((t) => t.isCompleted).length;

final double completionPercent =
    totalTasks == 0 ? 0.0 : (completedTasks / totalTasks).clamp(0.0, 1.0);

    final streak = calculateStreak(provider);
    final daysActive = activeDays(provider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Profile"),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// 👤 USER CARD
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [
                    theme.primaryColor,
                    theme.primaryColor.withOpacity(0.7),
                  ],
                ),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 30),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Welcome Back 👋",
                        style: TextStyle(
                            color: Colors.white, fontSize: 14),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Daily Tracker User",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),

             Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.local_fire_department,
                      color: Colors.orange),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      streak >= 5
                          ? "Amazing! You're on fire 🔥"
                          : streak > 0
                              ? "Keep going! Build your streak 💪"
                              : "Start today! Small steps matter 🚀",
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20,),

            /// 📊 STATS CARD
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Your Tasks",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _statItem("Total", totalTasks),
                      _statItem("Completed", completedTasks),
                      _statItem("Active Days", daysActive),
                      _statItem("Streak", streak),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// 📈 PROGRESS CARD
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Completion",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 16),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: completionPercent,
                      minHeight: 10,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "${(completionPercent * 100).toStringAsFixed(0)}% completed",
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// ⚙️ SETTINGS
            Container(
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [

                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text("Settings"),
                    onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Settings(),
                            ),
                          );
                        },
                  ),

                  const Divider(height: 1),

                  ListTile(
                    leading: const Icon(Icons.delete),
                    title: const Text("Clear All Tasks"),
                    onTap: () {
                      // implement clear logic
                    },
                  ),

                  const Divider(height: 1),

                  ListTile(
                    leading: const Icon(Icons.info),
                    title: const Text("About App"),
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 📊 Stat item widget
  Widget _statItem(String label, int value) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(label),
      ],
    );
  }
}