import 'package:daily_diary_app/screens/nav_screens/calender_screen.dart';
import 'package:daily_diary_app/screens/nav_screens/daily_task_screen.dart';
import 'package:daily_diary_app/screens/nav_screens/history_Screen.dart';
import 'package:daily_diary_app/screens/Inner_screens/profile_screen.dart';
import 'package:daily_diary_app/screens/Inner_screens/notes_screen.dart';
import 'package:daily_diary_app/screens/nav_screens/plan_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainVendorScreenState();
}
class _MainVendorScreenState extends State<MainScreen> {
  int _pageIndex = 0;

  final List<Widget> _pages = [
    CalendarScreen(), 
    PlanScreen(),
    HistoryScreen(),
    DailyTasksScreen(),
  
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     bottomNavigationBar:  BottomNavigationBar(
        currentIndex: _pageIndex,
        onTap: (value) {
          setState(() {
            _pageIndex = value;
          });
        },
        unselectedItemColor: AppBarTheme().iconTheme?.color,
        selectedItemColor: Colors.orange,
        type: BottomNavigationBarType.fixed,
        items: [
        BottomNavigationBarItem(icon: Icon(Icons.calendar_today),label: "Calender"),
        BottomNavigationBarItem(icon: Icon(Icons.loop),label: "Plan"),
         BottomNavigationBarItem(icon: Icon(Icons.history),label: "History"),
           BottomNavigationBarItem(icon: Icon(Icons.task),label: "Daily Tasks"),
      ]),
      body: _pages[_pageIndex],
    );
  }
}