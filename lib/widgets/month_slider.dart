import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthSlider extends StatelessWidget {
  final DateTime currentDate;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;

  const MonthSlider({
    Key? key,
    required this.currentDate,
    required this.onPreviousMonth,
    required this.onNextMonth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: onPreviousMonth,
            icon: const Icon(Icons.chevron_left, size: 28),
            style: IconButton.styleFrom(
              backgroundColor: theme.cardColor,
              foregroundColor: theme.primaryColor,
            ),
          ),
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 300),
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 10 * (1 - value)),
                  child: child,
                ),
              );
            },
            child: Text(
              DateFormat('MMMM yyyy').format(currentDate),
              style: theme.textTheme.displayMedium,
            ),
          ),
          IconButton(
            onPressed: onNextMonth,
            icon: const Icon(Icons.chevron_right, size: 28),
            style: IconButton.styleFrom(
              backgroundColor: theme.cardColor,
              foregroundColor: theme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
