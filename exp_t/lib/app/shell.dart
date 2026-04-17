part of '../main.dart';

class BudgetShell extends StatefulWidget {
  const BudgetShell({
    super.key,
    required this.isDarkMode,
    required this.onThemeModeChanged,
  });

  final bool isDarkMode;
  final ValueChanged<bool> onThemeModeChanged;

  @override
  State<BudgetShell> createState() => _BudgetShellState();
}

class _BudgetShellState extends State<BudgetShell> {
  final List<BudgetEntry> _entries = List<BudgetEntry>.from(sampleEntries);
  final UserProfile _profile = sampleProfile;

  int _selectedIndex = 0;
  bool _monthlyReminder = true;
  bool _carryOverPlan = true;
  bool _compactNumbers = false;
  bool _billAlerts = true;
  bool _biometricLock = false;
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

  void _openEntryDetails(BudgetEntry entry) {
    Navigator.of(context).push(
      _platformPageRoute(
        context: context,
        builder: (_) => EntryDetailScreen(entry: entry),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final titles = ['Overview', 'Entries', 'Add Entry', 'Profile', 'Settings'];
    final screens = [
      OverviewScreen(
        month: _selectedMonth,
        entries: _entriesForSelectedMonth,
        profile: _profile,
        onAddPressed: () => _selectTab(2),
        onEntrySelected: _openEntryDetails,
      ),
      EntriesScreen(
        month: _selectedMonth,
        entries: _entriesForSelectedMonth,
        onEntrySelected: _openEntryDetails,
      ),
      AddEntryScreen(initialMonth: _selectedMonth, onSaved: _saveEntry),
      ProfileScreen(
        profile: _profile,
        currentMonthEntries: _entriesForSelectedMonth,
      ),
      SettingsScreen(
        profile: _profile,
        isDarkMode: widget.isDarkMode,
        monthlyReminder: _monthlyReminder,
        carryOverPlan: _carryOverPlan,
        compactNumbers: _compactNumbers,
        billAlerts: _billAlerts,
        biometricLock: _biometricLock,
        onThemeModeChanged: widget.onThemeModeChanged,
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
        onBillAlertsChanged: (value) {
          setState(() {
            _billAlerts = value;
          });
        },
        onBiometricLockChanged: (value) {
          setState(() {
            _biometricLock = value;
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
            actions: _selectedIndex == 4
                ? null
                : [
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
                          avatar: const Icon(
                            Icons.calendar_month_outlined,
                            size: 18,
                          ),
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
                      icon: Icon(Icons.person_outline),
                      selectedIcon: Icon(Icons.person),
                      label: Text('Profile'),
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
                      icon: Icon(Icons.person_outline),
                      selectedIcon: Icon(Icons.person),
                      label: 'Profile',
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
