import 'package:daily_diary_app/widgets/calender_grid.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../main.dart';
import '../../providers/task_provider.dart';
import '../../widgets/month_slider.dart';
import '../notes_screen.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late PageController _pageController;
  DateTime _currentDate = DateTime.now();
  DateTime? _selectedDate;
  final int _initialPage = 12000;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _initialPage);
    _selectedDate = DateTime.now();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  DateTime _getDateForPage(int page) {
    final monthOffset = page - _initialPage;
    return DateTime(_currentDate.year, _currentDate.month + monthOffset, 1);
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentDate = _getDateForPage(page);
    });
  }

  void _goToToday() {
    setState(() {
      _currentDate = DateTime.now();
      _selectedDate = DateTime.now();
    });
    _pageController.jumpToPage(_initialPage);
  }

  void _clearSelection() {
    setState(() {
      _selectedDate = null;
    });
  }

  void _openNotesScreen(DateTime date) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NotesScreen(selectedDate: date)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final taskProvider = Provider.of<TaskProvider>(context);

    // Helper widget for color box + label
    Widget _buildColorLegend(Color color, String label) {
      return Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 6),
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ],
      );
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with title and theme toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Calendar', style: theme.textTheme.displayLarge),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now()),
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: IconButton(
                      icon: Icon(
                        themeProvider.isDarkMode
                            ? Icons.light_mode
                            : Icons.dark_mode,
                        color: theme.primaryColor,
                      ),
                      onPressed: themeProvider.toggleTheme,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Calendar Card
              Expanded(
                child: Card(
                  child: Column(
                    children: [
                      // Month Navigation Header
                      MonthSlider(
                        currentDate: _currentDate,
                        onPreviousMonth: () {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        onNextMonth: () {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                      ),

                      // Calendar Grid with PageView
                      Expanded(
                        child: PageView.builder(
                          controller: _pageController,
                          onPageChanged: _onPageChanged,
                          itemBuilder: (context, index) {
                            final date = _getDateForPage(index);
                            return CalendarGrid(
                              currentDate: date,
                              selectedDate: _selectedDate,
                              onDateSelected: (DateTime selected) {
                                setState(() {
                                  _selectedDate = selected;
                                });
                              },
                            );
                          },
                        ),
                      ),

                      // Selected Date Display
                      if (_selectedDate != null)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface,
                            border: Border(
                              top: BorderSide(
                                color: theme.brightness == Brightness.light
                                    ? const Color(0xFFFFD6B8)
                                    : const Color(0xFF404040),
                                width: 1,
                              ),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Selected Date',
                                        style: theme.textTheme.bodyMedium,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        DateFormat(
                                          'EEEE, MMMM d, yyyy',
                                        ).format(_selectedDate!),
                                        style: theme.textTheme.displayMedium
                                            ?.copyWith(fontSize: 18),
                                      ),
                                    ],
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: () =>
                                        _openNotesScreen(_selectedDate!),
                                    icon: const Icon(Icons.note_add, size: 18),
                                    label: const Text('Tasks'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: theme.primaryColor,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (taskProvider.hasTasksForDate(_selectedDate!))
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Row(
                                    children: [
                                      Icon(
                                        taskProvider.isDateCompleted(
                                              _selectedDate!,
                                            )
                                            ? Icons.check_circle
                                            : Icons.pending,
                                        size: 16,
                                        color:
                                            taskProvider.isDateCompleted(
                                              _selectedDate!,
                                            )
                                            ? const Color(0xFF4CAF50)
                                            : theme.primaryColor,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        taskProvider.isDateCompleted(
                                              _selectedDate!,
                                            )
                                            ? 'All tasks completed!'
                                            : '${taskProvider.getTasksForDate(_selectedDate!).length} task(s)',
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                              color:
                                                  taskProvider.isDateCompleted(
                                                    _selectedDate!,
                                                  )
                                                  ? const Color(0xFF4CAF50)
                                                  : null,
                                            ),
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
              ),

              const SizedBox(height: 16),

              // Place this above the Action Buttons Row
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildColorLegend(Colors.green, "Completed"),
                    _buildColorLegend(Colors.orange, "Pending"),
                    _buildColorLegend(Colors.yellowAccent, "On streak"),
                    _buildColorLegend(Colors.grey, "No Tasks"),
                  ],
                ),
              ),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _goToToday,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                      ),
                      child: const Text(
                        'Today',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _clearSelection,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.surface,
                        foregroundColor: theme.textTheme.bodyLarge?.color,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Clear',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
