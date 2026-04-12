import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'models/plan.dart';
import 'models/task.dart';

import 'providers/plan_provider.dart';
import 'providers/task_provider.dart';

import 'screens/main_screen.dart';
import 'themes/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// ✅ INIT HIVE
  await Hive.initFlutter();

  /// ✅ REGISTER ADAPTERS (IMPORTANT: only once)
  Hive.registerAdapter(PlanAdapter());
  Hive.registerAdapter(TaskAdapter());

  /// ✅ OPEN BOXES
  await Hive.openBox<Plan>('plansBox');
  await Hive.openBox<Task>('tasksBox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        /// ✅ THEME PROVIDER
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),

        /// ✅ TASK PROVIDER
        ChangeNotifierProvider(
          create: (_) => TaskProvider(),
        ),

        /// ✅ PLAN PROVIDER
        ChangeNotifierProvider(
          create: (_) => PlanProvider(),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: "Daily Diary",

            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,

            home: const MainScreen(),
          );
        },
      ),
    );
  }
}

/// ✅ THEME PROVIDER (CLEAN)
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void toggleTheme() {
    _themeMode =
        _themeMode == ThemeMode.light
            ? ThemeMode.dark
            : ThemeMode.light;

    notifyListeners();
  }
}