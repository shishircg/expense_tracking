part of '../main.dart';

List<DateTime> availableMonths(List<BudgetEntry> entries) {
  final seen = <String>{};
  final months = <DateTime>[];

  for (final entry in entries) {
    final month = monthKey(entry.date);
    final key = '${month.year}-${month.month}';
    if (seen.add(key)) {
      months.add(month);
    }
  }

  months.sort((a, b) => b.compareTo(a));
  return months;
}

PageRoute<T> _platformPageRoute<T>({
  required BuildContext context,
  required WidgetBuilder builder,
}) {
  switch (Theme.of(context).platform) {
    case TargetPlatform.iOS:
    case TargetPlatform.macOS:
      return CupertinoPageRoute<T>(builder: builder);
    case TargetPlatform.android:
    case TargetPlatform.fuchsia:
    case TargetPlatform.linux:
    case TargetPlatform.windows:
      return MaterialPageRoute<T>(builder: builder);
  }
}

int parseDueDay(String dueLabel) {
  final match = RegExp(r'(\d+)').firstMatch(dueLabel);
  return int.tryParse(match?.group(1) ?? '') ?? 1;
}

List<BudgetEntry> entriesForMonth(List<BudgetEntry> entries, DateTime month) {
  final selected = monthKey(month);
  return entries.where((entry) {
    final current = monthKey(entry.date);
    return current.year == selected.year && current.month == selected.month;
  }).toList();
}

Map<String, double> expenseBreakdown(List<BudgetEntry> entries) {
  final totals = <String, double>{};

  for (final entry in entries.where((item) => item.type == EntryType.expense)) {
    totals.update(
      entry.category,
      (value) => value + entry.amount,
      ifAbsent: () => entry.amount,
    );
  }

  return totals;
}

double totalFor(List<BudgetEntry> entries, EntryType type) {
  return entries
      .where((entry) => entry.type == type)
      .fold(0.0, (sum, entry) => sum + entry.amount);
}

DateTime monthKey(DateTime date) => DateTime(date.year, date.month);

String formatCurrency(double amount) => '\$${amount.toStringAsFixed(2)}';

String monthYearLabel(DateTime date) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${months[date.month - 1]} ${date.year}';
}

String formatShortDate(DateTime date) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${months[date.month - 1]} ${date.day}';
}

String formatLongDate(DateTime date) {
  const months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  return '${months[date.month - 1]} ${date.day}, ${date.year}';
}
