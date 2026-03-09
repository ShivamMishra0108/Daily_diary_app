import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'models/plan.dart';
import 'providers/plan_provider.dart';
import 'providers/task_provider.dart';
import 'screens/main_screen.dart';
import 'themes/app_theme.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  /// Initialize Hive
  await Hive.initFlutter();

  /// Register adapters
  Hive.registerAdapter(PlanAdapter());

  /// Open boxes
  await Hive.openBox<Plan>('plans');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MultiProvider(

      providers: [

        /// Theme Provider
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),

        /// Task Provider
        ChangeNotifierProvider(
          create: (_) => TaskProvider()..loadTasks(),
        ),

        /// Plan Provider
        ChangeNotifierProvider(
          create: (_) => PlanProvider()..init(),
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