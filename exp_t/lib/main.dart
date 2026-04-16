import 'package:flutter/material.dart';

void main() {
  runApp(const BudgetTrackerApp());
}

class BudgetTrackerApp extends StatelessWidget {
  const BudgetTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF1F6E5A),
      brightness: Brightness.light,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PocketLedger',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: scheme,
        scaffoldBackgroundColor: const Color(0xFFF6F7F8),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF6F7F8),
          surfaceTintColor: Colors.transparent,
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: const BorderSide(color: Color(0xFFE2E6E9)),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFD4DADF)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFD4DADF)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: scheme.primary),
          ),
        ),
      ),
      home: const BudgetShell(),
    );
  }
}

enum EntryType { income, expense }

class BudgetEntry {
  const BudgetEntry({
    required this.id,
    required this.title,
    required this.category,
    required this.type,
    required this.amount,
    required this.date,
    this.note = '',
  });

  final String id;
  final String title;
  final String category;
  final EntryType type;
  final double amount;
  final DateTime date;
  final String note;

  bool get isIncome => type == EntryType.income;
}

class BudgetShell extends StatefulWidget {
  const BudgetShell({super.key});

  @override
  State<BudgetShell> createState() => _BudgetShellState();
}

class _BudgetShellState extends State<BudgetShell> {
  final List<BudgetEntry> _entries = List<BudgetEntry>.from(sampleEntries);

  int _selectedIndex = 0;
  bool _monthlyReminder = true;
  bool _carryOverPlan = true;
  bool _compactNumbers = false;
  late DateTime _selectedMonth;

  @override
  void initState() {
    super.initState();
    _selectedMonth = availableMonths(_entries).first;
  }

  List<DateTime> get _months {
    final months = availableMonths(_entries);
    if (!months.contains(_selectedMonth)) {
      months.insert(0, _selectedMonth);
    }
    return months;
  }

  List<BudgetEntry> get _entriesForSelectedMonth =>
      entriesForMonth(_entries, _selectedMonth);

  void _selectTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _selectMonth(DateTime month) {
    setState(() {
      _selectedMonth = monthKey(month);
    });
  }

  void _saveEntry(BudgetEntry entry) {
    setState(() {
      _entries.insert(0, entry);
      _selectedMonth = monthKey(entry.date);
      _selectedIndex = 1;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${entry.title} saved to ${monthYearLabel(entry.date)}'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final titles = ['Overview', 'Entries', 'Add Entry', 'Settings'];
    final screens = [
      OverviewScreen(
        month: _selectedMonth,
        entries: _entriesForSelectedMonth,
        onAddPressed: () => _selectTab(2),
      ),
      EntriesScreen(month: _selectedMonth, entries: _entriesForSelectedMonth),
      AddEntryScreen(initialMonth: _selectedMonth, onSaved: _saveEntry),
      SettingsScreen(
        monthlyReminder: _monthlyReminder,
        carryOverPlan: _carryOverPlan,
        compactNumbers: _compactNumbers,
        onMonthlyReminderChanged: (value) {
          setState(() {
            _monthlyReminder = value;
          });
        },
        onCarryOverPlanChanged: (value) {
          setState(() {
            _carryOverPlan = value;
          });
        },
        onCompactNumbersChanged: (value) {
          setState(() {
            _compactNumbers = value;
          });
        },
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final useRail = constraints.maxWidth >= 780;

        return Scaffold(
          appBar: AppBar(
            title: Text(titles[_selectedIndex]),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: PopupMenuButton<DateTime>(
                  tooltip: 'Select month',
                  initialValue: _selectedMonth,
                  onSelected: _selectMonth,
                  itemBuilder: (context) {
                    return _months.map((month) {
                      return PopupMenuItem<DateTime>(
                        value: month,
                        child: Text(monthYearLabel(month)),
                      );
                    }).toList();
                  },
                  child: Chip(
                    avatar: const Icon(Icons.calendar_month_outlined, size: 18),
                    label: Text(monthYearLabel(_selectedMonth)),
                  ),
                ),
              ),
            ],
          ),
          body: Row(
            children: [
              if (useRail)
                NavigationRail(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: _selectTab,
                  labelType: NavigationRailLabelType.all,
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.pie_chart_outline),
                      selectedIcon: Icon(Icons.pie_chart),
                      label: Text('Overview'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.list_alt_outlined),
                      selectedIcon: Icon(Icons.list_alt),
                      label: Text('Entries'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.add_circle_outline),
                      selectedIcon: Icon(Icons.add_circle),
                      label: Text('Add'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.settings_outlined),
                      selectedIcon: Icon(Icons.settings),
                      label: Text('Settings'),
                    ),
                  ],
                ),
              Expanded(
                child: IndexedStack(index: _selectedIndex, children: screens),
              ),
            ],
          ),
          bottomNavigationBar: useRail
              ? null
              : NavigationBar(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: _selectTab,
                  destinations: const [
                    NavigationDestination(
                      icon: Icon(Icons.pie_chart_outline),
                      selectedIcon: Icon(Icons.pie_chart),
                      label: 'Overview',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.list_alt_outlined),
                      selectedIcon: Icon(Icons.list_alt),
                      label: 'Entries',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.add_circle_outline),
                      selectedIcon: Icon(Icons.add_circle),
                      label: 'Add',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.settings_outlined),
                      selectedIcon: Icon(Icons.settings),
                      label: 'Settings',
                    ),
                  ],
                ),
        );
      },
    );
  }
}

class OverviewScreen extends StatelessWidget {
  const OverviewScreen({
    super.key,
    required this.month,
    required this.entries,
    required this.onAddPressed,
  });

  final DateTime month;
  final List<BudgetEntry> entries;
  final VoidCallback onAddPressed;

  @override
  Widget build(BuildContext context) {
    final income = totalFor(entries, EntryType.income);
    final spending = totalFor(entries, EntryType.expense);
    final balance = income - spending;
    final categories = expenseBreakdown(entries).entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final recentEntries = List<BudgetEntry>.from(entries)
      ..sort((a, b) => b.date.compareTo(a.date));

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Monthly summary',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        Text(
          'Practical tracking for ${monthYearLabel(month)}.',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.black54),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final cards = [
              _SummaryCard(
                label: 'Income',
                value: formatCurrency(income),
                tone: const Color(0xFFE7F6EF),
                valueColor: const Color(0xFF1F7A46),
              ),
              _SummaryCard(
                label: 'Spent',
                value: formatCurrency(spending),
                tone: const Color(0xFFFDEFE9),
                valueColor: const Color(0xFFB8572A),
              ),
              _SummaryCard(
                label: 'Balance',
                value: formatCurrency(balance),
                tone: const Color(0xFFEAF0FC),
                valueColor: const Color(0xFF3059B8),
              ),
            ];

            if (constraints.maxWidth >= 720) {
              return Row(
                children: [
                  for (var i = 0; i < cards.length; i++) ...[
                    Expanded(child: cards[i]),
                    if (i != cards.length - 1) const SizedBox(width: 12),
                  ],
                ],
              );
            }

            return Column(
              children: [
                for (var i = 0; i < cards.length; i++) ...[
                  cards[i],
                  if (i != cards.length - 1) const SizedBox(height: 12),
                ],
              ],
            );
          },
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerLeft,
          child: FilledButton.icon(
            onPressed: onAddPressed,
            icon: const Icon(Icons.add),
            label: const Text('Add transaction'),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Spending by category',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        if (categories.isEmpty)
          const _InfoCard(message: 'No expense entries for this month yet.')
        else
          ...categories.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Card(
                child: ListTile(
                  title: Text(item.key),
                  trailing: Text(
                    formatCurrency(item.value),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            );
          }),
        const SizedBox(height: 14),
        Text(
          'Recent entries',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        if (recentEntries.isEmpty)
          const _InfoCard(message: 'No entries available for this month.')
        else
          ...recentEntries
              .take(5)
              .map(
                (entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: EntryTile(entry: entry),
                ),
              ),
      ],
    );
  }
}

class EntriesScreen extends StatefulWidget {
  const EntriesScreen({super.key, required this.month, required this.entries});

  final DateTime month;
  final List<BudgetEntry> entries;

  @override
  State<EntriesScreen> createState() => _EntriesScreenState();
}

class _EntriesScreenState extends State<EntriesScreen> {
  String _query = '';
  EntryType? _filter;

  @override
  Widget build(BuildContext context) {
    final visibleEntries = widget.entries.where((entry) {
      final query = _query.trim().toLowerCase();
      final matchesQuery =
          query.isEmpty ||
          entry.title.toLowerCase().contains(query) ||
          entry.category.toLowerCase().contains(query);
      final matchesType = _filter == null || entry.type == _filter;
      return matchesQuery && matchesType;
    }).toList()..sort((a, b) => b.date.compareTo(a.date));

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          '${visibleEntries.length} entries in ${monthYearLabel(widget.month)}',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        Text(
          'Search and review your monthly activity.',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.black54),
        ),
        const SizedBox(height: 16),
        TextField(
          decoration: const InputDecoration(
            labelText: 'Search entries',
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (value) {
            setState(() {
              _query = value;
            });
          },
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ChoiceChip(
              label: const Text('All'),
              selected: _filter == null,
              onSelected: (_) {
                setState(() {
                  _filter = null;
                });
              },
            ),
            ChoiceChip(
              label: const Text('Income'),
              selected: _filter == EntryType.income,
              onSelected: (_) {
                setState(() {
                  _filter = EntryType.income;
                });
              },
            ),
            ChoiceChip(
              label: const Text('Expense'),
              selected: _filter == EntryType.expense,
              onSelected: (_) {
                setState(() {
                  _filter = EntryType.expense;
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (visibleEntries.isEmpty)
          const _InfoCard(
            message: 'Nothing matches the current search or filter.',
          )
        else
          ...visibleEntries.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: EntryTile(entry: entry),
            ),
          ),
      ],
    );
  }
}

class AddEntryScreen extends StatefulWidget {
  const AddEntryScreen({
    super.key,
    required this.initialMonth,
    required this.onSaved,
  });

  final DateTime initialMonth;
  final ValueChanged<BudgetEntry> onSaved;

  @override
  State<AddEntryScreen> createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  late DateTime _date;
  EntryType _type = EntryType.expense;
  String _category = expenseCategories.first;

  List<String> get _categories =>
      _type == EntryType.income ? incomeCategories : expenseCategories;

  @override
  void initState() {
    super.initState();
    _date = DateTime(widget.initialMonth.year, widget.initialMonth.month, 5);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2025),
      lastDate: DateTime(2027),
    );

    if (picked != null) {
      setState(() {
        _date = picked;
      });
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final amount = double.parse(_amountController.text.trim());
    widget.onSaved(
      BudgetEntry(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        category: _category,
        type: _type,
        amount: amount,
        date: _date,
        note: _noteController.text.trim(),
      ),
    );

    _formKey.currentState!.reset();
    _titleController.clear();
    _amountController.clear();
    _noteController.clear();
    setState(() {
      _type = EntryType.expense;
      _category = expenseCategories.first;
      _date = DateTime(widget.initialMonth.year, widget.initialMonth.month, 5);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'New entry',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        Text(
          'Add income or expense for ${monthYearLabel(_date)}.',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.black54),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SegmentedButton<EntryType>(
                    segments: const [
                      ButtonSegment<EntryType>(
                        value: EntryType.expense,
                        label: Text('Expense'),
                        icon: Icon(Icons.arrow_upward),
                      ),
                      ButtonSegment<EntryType>(
                        value: EntryType.income,
                        label: Text('Income'),
                        icon: Icon(Icons.arrow_downward),
                      ),
                    ],
                    selected: {_type},
                    onSelectionChanged: (selection) {
                      setState(() {
                        _type = selection.first;
                        _category = _categories.first;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Enter a title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _amountController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Amount',
                      prefixText: '\$ ',
                    ),
                    validator: (value) {
                      final amount = double.tryParse(value ?? '');
                      if (amount == null || amount <= 0) {
                        return 'Enter a valid amount';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: _category,
                    decoration: const InputDecoration(labelText: 'Category'),
                    items: _categories.map((category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }
                      setState(() {
                        _category = value;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: _pickDate,
                    icon: const Icon(Icons.calendar_month_outlined),
                    label: Text('Date: ${formatShortDate(_date)}'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _noteController,
                    minLines: 2,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Note',
                      hintText: 'Optional note',
                    ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: _submit,
                    child: const Text('Save entry'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    super.key,
    required this.monthlyReminder,
    required this.carryOverPlan,
    required this.compactNumbers,
    required this.onMonthlyReminderChanged,
    required this.onCarryOverPlanChanged,
    required this.onCompactNumbersChanged,
  });

  final bool monthlyReminder;
  final bool carryOverPlan;
  final bool compactNumbers;
  final ValueChanged<bool> onMonthlyReminderChanged;
  final ValueChanged<bool> onCarryOverPlanChanged;
  final ValueChanged<bool> onCompactNumbersChanged;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Settings',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        Text(
          'Keep the prototype practical and focused on planning.',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.black54),
        ),
        const SizedBox(height: 16),
        Card(
          child: Column(
            children: [
              SwitchListTile.adaptive(
                title: const Text('Monthly reminder'),
                subtitle: const Text('Show a simple reminder preference.'),
                value: monthlyReminder,
                onChanged: onMonthlyReminderChanged,
              ),
              const Divider(height: 1),
              SwitchListTile.adaptive(
                title: const Text('Carry over remaining balance'),
                subtitle: const Text('Prototype planning for next month.'),
                value: carryOverPlan,
                onChanged: onCarryOverPlanChanged,
              ),
              const Divider(height: 1),
              SwitchListTile.adaptive(
                title: const Text('Compact numbers'),
                subtitle: const Text(
                  'Switch between detailed and compact totals.',
                ),
                value: compactNumbers,
                onChanged: onCompactNumbersChanged,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const _InfoCard(
          message:
              'This prototype stores sample data in memory only. It focuses on planning, monthly review, and simple entry management.',
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.label,
    required this.value,
    required this.tone,
    required this.valueColor,
  });

  final String label;
  final String value;
  final Color tone;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: tone,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.black54)),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: valueColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EntryTile extends StatelessWidget {
  const EntryTile({super.key, required this.entry});

  final BudgetEntry entry;

  @override
  Widget build(BuildContext context) {
    final valueColor = entry.isIncome
        ? const Color(0xFF1F7A46)
        : const Color(0xFFB8572A);

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: valueColor.withValues(alpha: 0.12),
          child: Icon(
            entry.isIncome ? Icons.south_west : Icons.north_east,
            color: valueColor,
          ),
        ),
        title: Text(entry.title),
        subtitle: Text('${entry.category} • ${formatShortDate(entry.date)}'),
        trailing: Text(
          '${entry.isIncome ? '+' : '-'}${formatCurrency(entry.amount)}',
          style: TextStyle(fontWeight: FontWeight.w700, color: valueColor),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(message, style: const TextStyle(color: Colors.black54)),
      ),
    );
  }
}

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
      ifAbsent: () {
        return entry.amount;
      },
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

const List<String> incomeCategories = [
  'Salary',
  'Freelance',
  'Bonus',
  'Refund',
];
const List<String> expenseCategories = [
  'Rent',
  'Food',
  'Transport',
  'Bills',
  'Health',
  'Shopping',
];

final List<BudgetEntry> sampleEntries = [
  BudgetEntry(
    id: '1',
    title: 'Salary',
    category: 'Salary',
    type: EntryType.income,
    amount: 3200,
    date: DateTime(2026, 4, 1),
  ),
  BudgetEntry(
    id: '2',
    title: 'Rent payment',
    category: 'Rent',
    type: EntryType.expense,
    amount: 1100,
    date: DateTime(2026, 4, 2),
  ),
  BudgetEntry(
    id: '3',
    title: 'Groceries',
    category: 'Food',
    type: EntryType.expense,
    amount: 142.75,
    date: DateTime(2026, 4, 5),
  ),
  BudgetEntry(
    id: '4',
    title: 'Freelance design',
    category: 'Freelance',
    type: EntryType.income,
    amount: 480,
    date: DateTime(2026, 4, 8),
  ),
  BudgetEntry(
    id: '5',
    title: 'Electric bill',
    category: 'Bills',
    type: EntryType.expense,
    amount: 89.50,
    date: DateTime(2026, 4, 10),
  ),
  BudgetEntry(
    id: '6',
    title: 'Train card',
    category: 'Transport',
    type: EntryType.expense,
    amount: 55,
    date: DateTime(2026, 4, 14),
  ),
  BudgetEntry(
    id: '7',
    title: 'Salary',
    category: 'Salary',
    type: EntryType.income,
    amount: 3200,
    date: DateTime(2026, 3, 1),
  ),
  BudgetEntry(
    id: '8',
    title: 'Bonus',
    category: 'Bonus',
    type: EntryType.income,
    amount: 250,
    date: DateTime(2026, 3, 9),
  ),
  BudgetEntry(
    id: '9',
    title: 'Medicine',
    category: 'Health',
    type: EntryType.expense,
    amount: 34,
    date: DateTime(2026, 3, 12),
  ),
  BudgetEntry(
    id: '10',
    title: 'Groceries',
    category: 'Food',
    type: EntryType.expense,
    amount: 128.90,
    date: DateTime(2026, 3, 20),
  ),
];
