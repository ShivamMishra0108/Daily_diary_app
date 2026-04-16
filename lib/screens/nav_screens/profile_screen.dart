import 'package:daily_diary_app/screens/Inner_screens/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';

import '../../providers/task_provider.dart';
import '../../models/profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Box<Profile> profileBox;
  Profile? profile;

  @override
  void initState() {
    super.initState();

    profileBox = Hive.box<Profile>('profileBox');

    if (profileBox.isNotEmpty) {
      profile = profileBox.getAt(0);
    }
  }

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

  int activeDays(TaskProvider provider) {
    final dates = provider.tasks
        .map((t) => DateTime(t.date.year, t.date.month, t.date.day))
        .toSet();
    return dates.length;
  }

  void _editField(
    BuildContext context,
    String title,
    String? currentValue,
    Function(String) onSave,
  ) {
    final controller = TextEditingController(text: currentValue);

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text("Edit $title"),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: "Enter $title"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                onSave(controller.text.trim());
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void _saveName(String val) {
    setState(() {
      if (profile == null) {
        profile = Profile(name: val, goal: "");
        profileBox.add(profile!);
      } else {
        profile!.name = val;
        profile!.save();
      }
    });
  }

  void _saveGoal(String val) {
    setState(() {
      if (profile == null) {
        profile = Profile(name: "", goal: val);
        profileBox.add(profile!);
      } else {
        profile!.goal = val;
        profile!.save();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = context.watch<TaskProvider>();

    final totalTasks = provider.tasks.length;
    final completedTasks = provider.tasks.where((t) => t.isCompleted).length;

    final double completionPercent = totalTasks == 0
        ? 0.0
        : (completedTasks / totalTasks).clamp(0.0, 1.0);

    final streak = calculateStreak(provider);
    final daysActive = activeDays(provider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(title: const Text("Profile")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
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

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Welcome 👋",
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          profile?.name.isNotEmpty == true
                              ? profile!.name
                              : "Add your name",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white),
                    onPressed: () {
                      _editField(context, "Name", profile?.name, _saveName);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.flag, color: Colors.blue),
                  const SizedBox(width: 10),

                  Expanded(
                    child: Text(
                      profile?.goal.isNotEmpty == true
                          ? profile!.goal
                          : "Set your goal for upcoming days ",
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),

                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      _editField(context, "Goal", profile?.goal, _saveGoal);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _statItem("Total", totalTasks),
                  _statItem("Completed", completedTasks),
                  _statItem("Active Days", daysActive),
                  _statItem("Streak", streak),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
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
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Container(
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  
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
                          leading: const Icon(Icons.delete, color: Colors.red),
                          title: const Text("Clear All Tasks"),
                          onTap: () async {
                            final confirm = await showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text("Confirm"),
                                content: const Text("Delete all tasks?"),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text("Cancel"),
                                  ),
                                  ElevatedButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: const Text("Delete"),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true) {
                              final provider = Provider.of<TaskProvider>(
                                context,
                                listen: false,
                              );

                              for (var task in provider.tasks) {
                                await task.delete();
                              }

                              provider.loadTasks();
                            }
                          },
                        ),

                        const Divider(height: 1),

                        ListTile(
                          leading: const Icon(Icons.info),
                          title: const Text("About App"),
                          onTap: () {
                            showAboutDialog(
                              context: context,
                              applicationName: "Daily Diary",
                              applicationVersion: "1.0.0",
                              applicationLegalese: "Made with Flutter 💙",
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statItem(String label, int value) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(label),
      ],
    );
  }
}
