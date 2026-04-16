import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const ExpensePrototypeApp());
}

class ExpensePrototypeApp extends StatelessWidget {
  const ExpensePrototypeApp({super.key});

  static const Color _background = Color(0xFFF4F6F3);
  static const Color _primary = Color(0xFF0F5E56);
  static const Color _primaryDark = Color(0xFF0B4B45);
  static const Color _accent = Color(0xFFC27A35);
  static const Color _text = Color(0xFF14242C);
  static const Color _muted = Color(0xFF63757C);
  static const Color _border = Color(0xFFD9E0DB);
  static const Color _surfaceAlt = Color(0xFFE8EEE8);

  @override
  Widget build(BuildContext context) {
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: _primary,
          brightness: Brightness.light,
        ).copyWith(
          primary: _primary,
          secondary: _accent,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          surface: Colors.white,
          onSurface: _text,
          outline: _border,
        );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PocketLedger',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: _background,
        appBarTheme: const AppBarTheme(
          backgroundColor: _background,
          foregroundColor: _text,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          labelStyle: const TextStyle(
            color: _muted,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
          hintStyle: const TextStyle(color: _muted, fontSize: 15),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22),
            borderSide: const BorderSide(color: _border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22),
            borderSide: const BorderSide(color: _border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22),
            borderSide: const BorderSide(color: _primary, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22),
            borderSide: const BorderSide(color: Colors.redAccent),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22),
            borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: ButtonStyle(
            minimumSize: WidgetStateProperty.all(const Size.fromHeight(56)),
            padding: WidgetStateProperty.all(
              const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
            ),
            textStyle: WidgetStateProperty.all(
              const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.disabled)) {
                return _primary.withValues(alpha: 0.32);
              }
              if (states.contains(WidgetState.pressed) ||
                  states.contains(WidgetState.hovered) ||
                  states.contains(WidgetState.focused)) {
                return _primaryDark;
              }
              return _primary;
            }),
            foregroundColor: WidgetStateProperty.all(Colors.white),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: ButtonStyle(
            minimumSize: WidgetStateProperty.all(const Size.fromHeight(56)),
            padding: WidgetStateProperty.all(
              const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
            ),
            textStyle: WidgetStateProperty.all(
              const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            side: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.focused) ||
                  states.contains(WidgetState.hovered)) {
                return const BorderSide(color: _primary, width: 1.5);
              }
              return const BorderSide(color: _border);
            }),
            foregroundColor: WidgetStateProperty.all(_text),
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.pressed)) {
                return _surfaceAlt;
              }
              return Colors.white;
            }),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            ),
          ),
        ),
        chipTheme: ChipThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          side: const BorderSide(color: _border),
          backgroundColor: Colors.white,
          labelStyle: const TextStyle(
            color: _text,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          selectedColor: _primary.withValues(alpha: 0.12),
          secondaryLabelStyle: const TextStyle(
            color: _primary,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          indicatorColor: _primary.withValues(alpha: 0.12),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            final selected = states.contains(WidgetState.selected);
            return TextStyle(
              color: selected ? _primary : _muted,
              fontSize: 12,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
            );
          }),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            final selected = states.contains(WidgetState.selected);
            return IconThemeData(color: selected ? _primary : _muted, size: 24);
          }),
          height: 78,
        ),
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          backgroundColor: _text,
          contentTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
      onGenerateRoute: (settings) {
        if (settings.name == ExpenseDetailScreen.routeName) {
          final expense = settings.arguments as ExpenseEntry;
          return MaterialPageRoute<void>(
            builder: (_) => ExpenseDetailScreen(expense: expense),
          );
        }
        return null;
      },
      home: const ExpenseShell(),
    );
  }
}

class ExpenseShell extends StatefulWidget {
  const ExpenseShell({super.key});

  @override
  State<ExpenseShell> createState() => _ExpenseShellState();
}

class _ExpenseShellState extends State<ExpenseShell> {
  static const double _monthlyBudget = 3400;

  final List<ExpenseEntry> _expenses = List<ExpenseEntry>.from(sampleExpenses);

  int _selectedIndex = 0;
  bool _weeklyDigest = true;
  bool _highContrast = false;
  bool _smartHints = true;
  bool _biometricPreview = false;

  void _selectTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _openExpenseDetails(ExpenseEntry expense) {
    Navigator.of(
      context,
    ).pushNamed(ExpenseDetailScreen.routeName, arguments: expense);
  }

  void _createExpense(ExpenseEntry expense) {
    setState(() {
      _expenses.insert(0, expense);
      _selectedIndex = 1;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${expense.title} added to ${expense.category} for ${formatCurrency(expense.amount)}.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final titles = <String>[
      'PocketLedger',
      'Transactions',
      'Add Expense',
      'Profile & Settings',
    ];
    final subtitles = <String>[
      'A calm overview of your monthly spending',
      'Search, filter, and review every payment',
      'Prototype a new expense in seconds',
      'Preferences, accessibility, and product notes',
    ];
    final screens = <Widget>[
      DashboardScreen(
        expenses: _expenses,
        categories: expenseCategories,
        monthlyBudget: _monthlyBudget,
        onNavigateToTab: _selectTab,
        onExpenseSelected: _openExpenseDetails,
      ),
      TransactionsScreen(
        expenses: _expenses,
        categories: expenseCategories,
        monthlyBudget: _monthlyBudget,
        onExpenseSelected: _openExpenseDetails,
      ),
      AddExpenseScreen(
        categories: expenseCategories,
        onCreateExpense: _createExpense,
      ),
      SettingsScreen(
        weeklyDigest: _weeklyDigest,
        highContrast: _highContrast,
        smartHints: _smartHints,
        biometricPreview: _biometricPreview,
        onWeeklyDigestChanged: (value) {
          setState(() {
            _weeklyDigest = value;
          });
        },
        onHighContrastChanged: (value) {
          setState(() {
            _highContrast = value;
          });
        },
        onSmartHintsChanged: (value) {
          setState(() {
            _smartHints = value;
          });
        },
        onBiometricPreviewChanged: (value) {
          setState(() {
            _biometricPreview = value;
          });
        },
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 760;

        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 82,
            titleSpacing: 20,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  titles[_selectedIndex],
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF14242C),
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitles[_selectedIndex],
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF63757C),
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                tooltip: 'Open stakeholder notes',
                onPressed: () {
                  showDialog<void>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Prototype Notes'),
                        content: const Text(
                          'This prototype focuses on the user interface only. All balances, budgets, and expenses are dummy data for usability testing.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Close'),
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: const Icon(CupertinoIcons.doc_text_search),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: CircleAvatar(
                  radius: 21,
                  backgroundColor: const Color(
                    0xFF0F5E56,
                  ).withValues(alpha: 0.12),
                  child: const Icon(
                    CupertinoIcons.person_crop_circle_fill,
                    color: Color(0xFF0F5E56),
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
          body: SafeArea(
            top: false,
            child: Row(
              children: [
                if (isWide)
                  Container(
                    width: 112,
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
                    child: _AdaptiveNavigationRail(
                      selectedIndex: _selectedIndex,
                      onDestinationSelected: _selectTab,
                    ),
                  ),
                if (isWide)
                  const VerticalDivider(
                    width: 1,
                    thickness: 1,
                    color: Color(0xFFD9E0DB),
                  ),
                Expanded(
                  child: IndexedStack(index: _selectedIndex, children: screens),
                ),
              ],
            ),
          ),
          bottomNavigationBar: isWide
              ? null
              : _AdaptiveBottomNavigation(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: _selectTab,
                ),
        );
      },
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({
    super.key,
    required this.expenses,
    required this.categories,
    required this.monthlyBudget,
    required this.onNavigateToTab,
    required this.onExpenseSelected,
  });

  final List<ExpenseEntry> expenses;
  final List<ExpenseCategory> categories;
  final double monthlyBudget;
  final ValueChanged<int> onNavigateToTab;
  final ValueChanged<ExpenseEntry> onExpenseSelected;

  @override
  Widget build(BuildContext context) {
    final totalSpent = expenses.fold<double>(
      0,
      (sum, expense) => sum + expense.amount,
    );
    final remaining = (monthlyBudget - totalSpent)
        .clamp(0, monthlyBudget)
        .toDouble();
    final budgetProgress = (totalSpent / monthlyBudget)
        .clamp(0.0, 1.0)
        .toDouble();
    final recurringCount = expenses
        .where((expense) => expense.isRecurring)
        .length;
    final width = MediaQuery.sizeOf(context).width;
    final compactButtons = width < 400;
    final topExpenses = List<ExpenseEntry>.from(expenses)
      ..sort((a, b) => b.amount.compareTo(a.amount));

    return Scrollbar(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final useWideMetrics = constraints.maxWidth >= 820;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Semantics(
                  container: true,
                  label:
                      'Monthly snapshot. ${formatCurrency(totalSpent)} spent from a ${formatCurrency(monthlyBudget)} budget. ${formatCurrency(remaining)} remaining.',
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF103D4B),
                          Color(0xFF0F5E56),
                          Color(0xFF13836F),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.16),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: const Text(
                            'APRIL SNAPSHOT',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              letterSpacing: 1.4,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          'Track every rupee with clarity.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            height: 1.1,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.8,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'PocketLedger turns spending into a simple story with clear categories, touch-friendly actions, and a calm visual hierarchy.',
                          style: TextStyle(
                            color: Color(0xFFE7F7F2),
                            fontSize: 15,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          formatCurrency(remaining),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 38,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -1,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'remaining from this month\'s budget',
                          style: TextStyle(
                            color: Color(0xFFE7F7F2),
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _AccessibleProgressBar(
                          value: budgetProgress,
                          fillColor: Colors.white,
                          trackColor: Colors.white24,
                          label:
                              'Budget progress. ${percentageText(budgetProgress)} of the monthly budget has been used.',
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            const Text(
                              'Spent',
                              style: TextStyle(
                                color: Color(0xFFD3EFE6),
                                fontSize: 14,
                              ),
                            ),
                            const Spacer(),
                            Flexible(
                              child: Text(
                                '${formatCurrency(totalSpent)} / ${formatCurrency(monthlyBudget)}',
                                textAlign: TextAlign.end,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        compactButtons
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  FilledButton.icon(
                                    onPressed: () => onNavigateToTab(2),
                                    icon: const Icon(Icons.add_circle_outline),
                                    label: const Text('Log an expense'),
                                  ),
                                  const SizedBox(height: 12),
                                  OutlinedButton.icon(
                                    onPressed: () => onNavigateToTab(1),
                                    icon: const Icon(
                                      Icons.receipt_long_outlined,
                                    ),
                                    label: const Text('See transactions'),
                                  ),
                                ],
                              )
                            : Wrap(
                                spacing: 12,
                                runSpacing: 12,
                                children: [
                                  ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      minWidth: 200,
                                    ),
                                    child: FilledButton.icon(
                                      onPressed: () => onNavigateToTab(2),
                                      icon: const Icon(
                                        Icons.add_circle_outline,
                                      ),
                                      label: const Text('Log an expense'),
                                    ),
                                  ),
                                  ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      minWidth: 200,
                                    ),
                                    child: OutlinedButton.icon(
                                      onPressed: () => onNavigateToTab(1),
                                      icon: const Icon(
                                        Icons.receipt_long_outlined,
                                      ),
                                      label: const Text('See transactions'),
                                    ),
                                  ),
                                ],
                              ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                useWideMetrics
                    ? Row(
                        children: [
                          Expanded(
                            child: _MetricCard(
                              label: 'This month',
                              value: formatCurrency(totalSpent),
                              helper: 'Across ${expenses.length} transactions',
                              icon: CupertinoIcons.chart_bar_alt_fill,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _MetricCard(
                              label: 'Recurring bills',
                              value: '$recurringCount',
                              helper: 'Subscriptions and utilities',
                              icon: CupertinoIcons.repeat,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _MetricCard(
                              label: 'Best category cushion',
                              value: mostComfortableCategory(
                                categories,
                                expenses,
                              ),
                              helper: 'Lowest spend vs budget pressure',
                              icon: CupertinoIcons.shield_lefthalf_fill,
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          _MetricCard(
                            label: 'This month',
                            value: formatCurrency(totalSpent),
                            helper: 'Across ${expenses.length} transactions',
                            icon: CupertinoIcons.chart_bar_alt_fill,
                          ),
                          const SizedBox(height: 12),
                          _MetricCard(
                            label: 'Recurring bills',
                            value: '$recurringCount',
                            helper: 'Subscriptions and utilities',
                            icon: CupertinoIcons.repeat,
                          ),
                          const SizedBox(height: 12),
                          _MetricCard(
                            label: 'Best category cushion',
                            value: mostComfortableCategory(
                              categories,
                              expenses,
                            ),
                            helper: 'Lowest spend vs budget pressure',
                            icon: CupertinoIcons.shield_lefthalf_fill,
                          ),
                        ],
                      ),
                const SizedBox(height: 28),
                _SectionTitle(
                  title: 'Budget rhythm',
                  subtitle:
                      'Quick insight cards highlight where the prototype supports scanning and comparison.',
                ),
                const SizedBox(height: 14),
                Column(
                  children: categories.map((category) {
                    final spent = spentForCategory(expenses, category.name);
                    final progress = (spent / category.monthlyBudget).clamp(
                      0.0,
                      1.0,
                    );
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _InsightCard(
                        category: category,
                        spent: spent,
                        progress: progress,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 28),
                _SectionTitle(
                  title: 'Recent highlights',
                  subtitle:
                      'Tap any card to review detail states and routed navigation.',
                  trailing: TextButton(
                    onPressed: () => onNavigateToTab(1),
                    child: const Text('View all'),
                  ),
                ),
                const SizedBox(height: 14),
                Column(
                  children: topExpenses.take(3).map((expense) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _ExpenseListCard(
                        expense: expense,
                        onTap: () => onExpenseSelected(expense),
                      ),
                    );
                  }).toList(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({
    super.key,
    required this.expenses,
    required this.categories,
    required this.monthlyBudget,
    required this.onExpenseSelected,
  });

  final List<ExpenseEntry> expenses;
  final List<ExpenseCategory> categories;
  final double monthlyBudget;
  final ValueChanged<ExpenseEntry> onExpenseSelected;

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  String _selectedFilter = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filters = <String>[
      'All',
      ...widget.categories.map((category) => category.name),
    ];
    final filteredExpenses = widget.expenses.where((expense) {
      final matchesFilter =
          _selectedFilter == 'All' || expense.category == _selectedFilter;
      final query = _searchQuery.trim().toLowerCase();
      final matchesQuery =
          query.isEmpty ||
          expense.title.toLowerCase().contains(query) ||
          expense.merchant.toLowerCase().contains(query) ||
          expense.note.toLowerCase().contains(query);
      return matchesFilter && matchesQuery;
    }).toList()..sort((a, b) => b.date.compareTo(a.date));

    final filteredTotal = filteredExpenses.fold<double>(
      0,
      (sum, expense) => sum + expense.amount,
    );
    void resetFilters() {
      _searchController.clear();
      setState(() {
        _selectedFilter = 'All';
        _searchQuery = '';
      });
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 860;
          final summaryPanel = _FilterSummaryCard(
            totalResults: filteredExpenses.length,
            totalAmount: filteredTotal,
            activeFilter: _selectedFilter,
            searchQuery: _searchQuery,
            searchController: _searchController,
            monthlyBudget: widget.monthlyBudget,
            categories: widget.categories,
            expenses: widget.expenses,
            onSearchChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            onFilterSelected: (value) {
              setState(() {
                _selectedFilter = value;
              });
            },
            filters: filters,
          );

          final listPanel = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionTitle(
                title: 'Recent activity',
                subtitle:
                    '${filteredExpenses.length} result${filteredExpenses.length == 1 ? '' : 's'} ready for review.',
              ),
              const SizedBox(height: 14),
              Expanded(
                child: filteredExpenses.isEmpty
                    ? _EmptyStateCard(
                        title: 'No matching transactions',
                        description:
                            'Try another search term or clear the category filter to see more dummy data.',
                        actionLabel: 'Reset filters',
                        onAction: resetFilters,
                      )
                    : Scrollbar(
                        child: ListView.separated(
                          itemCount: filteredExpenses.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final expense = filteredExpenses[index];
                            return _ExpenseListCard(
                              expense: expense,
                              onTap: () => widget.onExpenseSelected(expense),
                            );
                          },
                        ),
                      ),
              ),
            ],
          );

          if (isWide) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 306, child: summaryPanel),
                const SizedBox(width: 16),
                Expanded(child: listPanel),
              ],
            );
          }

          return Scrollbar(
            child: ListView(
              children: [
                summaryPanel,
                const SizedBox(height: 16),
                _SectionTitle(
                  title: 'Recent activity',
                  subtitle:
                      '${filteredExpenses.length} result${filteredExpenses.length == 1 ? '' : 's'} ready for review.',
                ),
                const SizedBox(height: 14),
                if (filteredExpenses.isEmpty)
                  SizedBox(
                    height: 280,
                    child: _EmptyStateCard(
                      title: 'No matching transactions',
                      description:
                          'Try another search term or clear the category filter to see more dummy data.',
                      actionLabel: 'Reset filters',
                      onAction: resetFilters,
                    ),
                  )
                else ...[
                  for (var index = 0; index < filteredExpenses.length; index++)
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: index == filteredExpenses.length - 1 ? 0 : 12,
                      ),
                      child: _ExpenseListCard(
                        expense: filteredExpenses[index],
                        onTap: () =>
                            widget.onExpenseSelected(filteredExpenses[index]),
                      ),
                    ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({
    super.key,
    required this.categories,
    required this.onCreateExpense,
  });

  final List<ExpenseCategory> categories;
  final ValueChanged<ExpenseEntry> onCreateExpense;

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _merchantController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  late String _selectedCategory;
  String _paymentMethod = 'Card';
  bool _isRecurring = false;
  DateTime _selectedDate = DateTime(2026, 4, 17);

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.categories.first.name;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _merchantController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    setState(() {
      _titleController.clear();
      _merchantController.clear();
      _amountController.clear();
      _noteController.clear();
      _selectedCategory = widget.categories.first.name;
      _paymentMethod = 'Card';
      _isRecurring = false;
      _selectedDate = DateTime(2026, 4, 17);
    });
  }

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2025),
      lastDate: DateTime(2027),
      helpText: 'Select expense date',
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final amount = double.tryParse(_amountController.text.trim());
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please provide a valid amount greater than zero.'),
        ),
      );
      return;
    }

    final category = widget.categories.firstWhere(
      (item) => item.name == _selectedCategory,
    );

    widget.onCreateExpense(
      ExpenseEntry(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        merchant: _merchantController.text.trim(),
        amount: amount,
        category: category.name,
        date: _selectedDate,
        note: _noteController.text.trim().isEmpty
            ? 'Created from the prototype form'
            : _noteController.text.trim(),
        paymentMethod: _paymentMethod,
        isRecurring: _isRecurring,
      ),
    );

    _resetForm();
  }

  @override
  Widget build(BuildContext context) {
    final selectedCategory = widget.categories.firstWhere(
      (category) => category.name == _selectedCategory,
    );
    final previewAmount = double.tryParse(_amountController.text.trim()) ?? 0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final useSideBySide = constraints.maxWidth >= 900;
          final formCard = SurfaceCard(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Scrollbar(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    const Text(
                      'New expense',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Prototype the entry experience with clear labels, generous spacing, and adaptive controls.',
                      style: TextStyle(
                        color: Color(0xFF63757C),
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _titleController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Expense title',
                        hintText: 'Coffee catch-up',
                      ),
                      onChanged: (_) => setState(() {}),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Add a short title';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _merchantController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Merchant or payee',
                        hintText: 'Local cafe',
                      ),
                      onChanged: (_) => setState(() {}),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Add a merchant name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    LayoutBuilder(
                      builder: (context, fieldConstraints) {
                        final stackFields = fieldConstraints.maxWidth < 480;
                        final amountField = TextFormField(
                          controller: _amountController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Amount',
                            hintText: '42.50',
                            prefixText: '\$ ',
                          ),
                          onChanged: (_) => setState(() {}),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Add an amount';
                            }
                            if (double.tryParse(value.trim()) == null) {
                              return 'Use numbers only';
                            }
                            return null;
                          },
                        );
                        final categoryField = DropdownButtonFormField<String>(
                          initialValue: _selectedCategory,
                          decoration: const InputDecoration(
                            labelText: 'Category',
                          ),
                          items: widget.categories.map((category) {
                            return DropdownMenuItem<String>(
                              value: category.name,
                              child: Text(category.name),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value == null) {
                              return;
                            }
                            setState(() {
                              _selectedCategory = value;
                            });
                          },
                        );

                        if (stackFields) {
                          return Column(
                            children: [
                              amountField,
                              const SizedBox(height: 14),
                              categoryField,
                            ],
                          );
                        }

                        return Row(
                          children: [
                            Expanded(child: amountField),
                            const SizedBox(width: 14),
                            Expanded(child: categoryField),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 14),
                    Semantics(
                      label:
                          'Payment method selector. Current method is $_paymentMethod.',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Payment method',
                            style: TextStyle(
                              color: Color(0xFF63757C),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 10),
                          SegmentedButton<String>(
                            segments: const [
                              ButtonSegment<String>(
                                value: 'Card',
                                icon: Icon(Icons.credit_card_outlined),
                                label: Text('Card'),
                              ),
                              ButtonSegment<String>(
                                value: 'Cash',
                                icon: Icon(Icons.payments_outlined),
                                label: Text('Cash'),
                              ),
                              ButtonSegment<String>(
                                value: 'Transfer',
                                icon: Icon(Icons.compare_arrows_outlined),
                                label: Text('Transfer'),
                              ),
                            ],
                            selected: {_paymentMethod},
                            onSelectionChanged: (selection) {
                              setState(() {
                                _paymentMethod = selection.first;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    SurfaceCard(
                      padding: const EdgeInsets.all(18),
                      color: const Color(0xFFE8EEE8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Date and repeat behavior',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 10),
                          OutlinedButton.icon(
                            onPressed: _pickDate,
                            icon: const Icon(Icons.calendar_today_outlined),
                            label: Text(formatLongDate(_selectedDate)),
                          ),
                          const SizedBox(height: 8),
                          SwitchListTile.adaptive(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('Repeat monthly'),
                            subtitle: const Text(
                              'Use for subscriptions, rent, or utilities.',
                            ),
                            value: _isRecurring,
                            onChanged: (value) {
                              setState(() {
                                _isRecurring = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _noteController,
                      minLines: 3,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        labelText: 'Notes',
                        hintText: 'Add context for interviews or testing.',
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 16),
                    LayoutBuilder(
                      builder: (context, actionConstraints) {
                        final stackButtons = actionConstraints.maxWidth < 420;
                        if (stackButtons) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              FilledButton.icon(
                                onPressed: _submit,
                                icon: const Icon(Icons.check_circle_outline),
                                label: const Text('Save expense'),
                              ),
                              const SizedBox(height: 12),
                              OutlinedButton.icon(
                                onPressed: _resetForm,
                                icon: const Icon(Icons.refresh_outlined),
                                label: const Text('Clear form'),
                              ),
                            ],
                          );
                        }

                        return Row(
                          children: [
                            Expanded(
                              child: FilledButton.icon(
                                onPressed: _submit,
                                icon: const Icon(Icons.check_circle_outline),
                                label: const Text('Save expense'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: _resetForm,
                                icon: const Icon(Icons.refresh_outlined),
                                label: const Text('Clear form'),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );

          final previewCard = SurfaceCard(
            padding: const EdgeInsets.all(20),
            child: Scrollbar(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const Text(
                    'Live preview',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'This mirrored state helps stakeholders test how feedback changes as users type.',
                    style: TextStyle(
                      color: Color(0xFF63757C),
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: selectedCategory.color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 56,
                          width: 56,
                          decoration: BoxDecoration(
                            color: selectedCategory.color.withValues(
                              alpha: 0.18,
                            ),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Icon(
                            selectedCategory.icon,
                            color: selectedCategory.color,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _titleController.text.trim().isEmpty
                                    ? 'Expense title'
                                    : _titleController.text.trim(),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _merchantController.text.trim().isEmpty
                                    ? 'Merchant name'
                                    : _merchantController.text.trim(),
                                style: const TextStyle(
                                  color: Color(0xFF63757C),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Flexible(
                          child: Text(
                            formatCurrency(previewAmount),
                            textAlign: TextAlign.end,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SurfaceCard(
                    color: const Color(0xFFEFF4F0),
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            _InfoChip(
                              icon: selectedCategory.icon,
                              label: _selectedCategory,
                            ),
                            _InfoChip(
                              icon: Icons.calendar_today_outlined,
                              label: formatShortDate(_selectedDate),
                            ),
                            _InfoChip(
                              icon: Icons.wallet_outlined,
                              label: _paymentMethod,
                            ),
                            if (_isRecurring)
                              const _InfoChip(
                                icon: Icons.autorenew,
                                label: 'Recurring',
                              ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          'Prototype note',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _noteController.text.trim().isEmpty
                              ? 'Stakeholders can review empty-state handling here before a user adds notes.'
                              : _noteController.text.trim(),
                          style: const TextStyle(
                            color: Color(0xFF45565E),
                            fontSize: 15,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 18),
                        const Divider(height: 28),
                        Semantics(
                          label:
                              'Accessibility checklist. Large touch target, readable contrast, and clear field grouping are included.',
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _ChecklistItem('Large buttons for thumb reach'),
                              _ChecklistItem(
                                'High contrast heading and amount',
                              ),
                              _ChecklistItem('Form labels remain visible'),
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

          if (useSideBySide) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 11, child: formCard),
                const SizedBox(width: 16),
                Expanded(flex: 9, child: previewCard),
              ],
            );
          }

          return Column(
            children: [
              Expanded(child: formCard),
              const SizedBox(height: 16),
              SizedBox(height: 380, child: previewCard),
            ],
          );
        },
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    super.key,
    required this.weeklyDigest,
    required this.highContrast,
    required this.smartHints,
    required this.biometricPreview,
    required this.onWeeklyDigestChanged,
    required this.onHighContrastChanged,
    required this.onSmartHintsChanged,
    required this.onBiometricPreviewChanged,
  });

  final bool weeklyDigest;
  final bool highContrast;
  final bool smartHints;
  final bool biometricPreview;
  final ValueChanged<bool> onWeeklyDigestChanged;
  final ValueChanged<bool> onHighContrastChanged;
  final ValueChanged<bool> onSmartHintsChanged;
  final ValueChanged<bool> onBiometricPreviewChanged;

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final useWideGrid = constraints.maxWidth >= 860;
            final preferences = SurfaceCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Experience settings',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Adaptive switches are used here to feel native on both Android and iOS.',
                    style: TextStyle(
                      color: Color(0xFF63757C),
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SwitchListTile.adaptive(
                    title: const Text('Weekly digest preview'),
                    subtitle: const Text(
                      'Show a summary email card in usability tests.',
                    ),
                    value: weeklyDigest,
                    onChanged: onWeeklyDigestChanged,
                  ),
                  SwitchListTile.adaptive(
                    title: const Text('High-contrast preview'),
                    subtitle: const Text(
                      'Demonstrates awareness of accessible color pairings.',
                    ),
                    value: highContrast,
                    onChanged: onHighContrastChanged,
                  ),
                  SwitchListTile.adaptive(
                    title: const Text('Smart hints'),
                    subtitle: const Text(
                      'Surface inline guidance during the form flow.',
                    ),
                    value: smartHints,
                    onChanged: onSmartHintsChanged,
                  ),
                  SwitchListTile.adaptive(
                    title: const Text('Biometric sign-in placeholder'),
                    subtitle: const Text(
                      'UI-only toggle without authentication logic.',
                    ),
                    value: biometricPreview,
                    onChanged: onBiometricPreviewChanged,
                  ),
                ],
              ),
            );

            final accessibility = SurfaceCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Accessibility notes',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'The prototype uses readable type, logical grouping, semantic labels, and large tap areas for common actions.',
                    style: TextStyle(
                      color: Color(0xFF63757C),
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 16),
                  _ChecklistItem('Clear page titles and descriptive subtitles'),
                  _ChecklistItem(
                    'Form labels remain visible instead of placeholder-only prompts',
                  ),
                  _ChecklistItem(
                    'Buttons keep at least a 56 pixel touch height',
                  ),
                  _ChecklistItem(
                    'Content order follows the visual reading flow',
                  ),
                ],
              ),
            );

            final about = SurfaceCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 52,
                        width: 52,
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFF0F5E56,
                          ).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.account_balance_wallet_outlined,
                          color: Color(0xFF0F5E56),
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'PocketLedger',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Cross-platform expense tracking prototype',
                              style: TextStyle(
                                color: Color(0xFF63757C),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'This project is intentionally UI-only: balances, categories, and notifications are all hardcoded to support fast stakeholder feedback.',
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.6,
                      color: Color(0xFF45565E),
                    ),
                  ),
                  const SizedBox(height: 18),
                  FilledButton.tonalIcon(
                    onPressed: () {
                      showAboutDialog(
                        context: context,
                        applicationName: 'PocketLedger',
                        applicationVersion: 'Prototype 1.0',
                        applicationLegalese:
                            'Design prototype for cross-platform stakeholder review.',
                      );
                    },
                    icon: const Icon(Icons.info_outline),
                    label: const Text('Open about dialog'),
                  ),
                ],
              ),
            );

            if (useWideGrid) {
              return Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: preferences),
                      const SizedBox(width: 16),
                      Expanded(child: accessibility),
                    ],
                  ),
                  const SizedBox(height: 16),
                  about,
                ],
              );
            }

            return Column(
              children: [
                preferences,
                const SizedBox(height: 16),
                accessibility,
                const SizedBox(height: 16),
                about,
              ],
            );
          },
        ),
      ),
    );
  }
}

class ExpenseDetailScreen extends StatelessWidget {
  const ExpenseDetailScreen({super.key, required this.expense});

  static const String routeName = '/expense-detail';

  final ExpenseEntry expense;

  @override
  Widget build(BuildContext context) {
    final category = categoryFor(expense.category);

    return Scaffold(
      appBar: AppBar(title: const Text('Expense Detail')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final useWideLayout = constraints.maxWidth >= 760;
              final summary = SurfaceCard(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            color: category.color.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Icon(
                            category.icon,
                            color: category.color,
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                expense.title,
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.7,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                expense.merchant,
                                style: const TextStyle(
                                  color: Color(0xFF63757C),
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      formatCurrency(expense.amount),
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        _InfoChip(icon: category.icon, label: expense.category),
                        _InfoChip(
                          icon: Icons.calendar_today_outlined,
                          label: formatLongDate(expense.date),
                        ),
                        _InfoChip(
                          icon: Icons.wallet_outlined,
                          label: expense.paymentMethod,
                        ),
                        if (expense.isRecurring)
                          const _InfoChip(
                            icon: Icons.autorenew,
                            label: 'Recurring',
                          ),
                      ],
                    ),
                  ],
                ),
              );

              final detailPanel = SurfaceCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Detail notes',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      expense.note,
                      style: const TextStyle(
                        fontSize: 15,
                        height: 1.7,
                        color: Color(0xFF45565E),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Divider(height: 1),
                    const SizedBox(height: 20),
                    const Text(
                      'Prototype timeline',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const _TimelineRow(
                      title: 'Expense captured',
                      description:
                          'The card is added to the transaction list instantly for testing.',
                    ),
                    const _TimelineRow(
                      title: 'Budget category updated',
                      description:
                          'The dashboard progress bars react to the new amount.',
                    ),
                    const _TimelineRow(
                      title: 'Ready for stakeholder review',
                      description:
                          'This route demonstrates a readable detail state with contextual metadata.',
                    ),
                    const SizedBox(height: 20),
                    FilledButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Review state captured for the prototype demo.',
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.task_alt_outlined),
                      label: const Text('Mark reviewed'),
                    ),
                  ],
                ),
              );

              if (useWideLayout) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 11, child: summary),
                    const SizedBox(width: 16),
                    Expanded(flex: 9, child: detailPanel),
                  ],
                );
              }

              return ListView(
                children: [summary, const SizedBox(height: 16), detailPanel],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _AdaptiveNavigationRail extends StatelessWidget {
  const _AdaptiveNavigationRail({
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      selectedIndex: selectedIndex,
      useIndicator: true,
      minWidth: 72,
      labelType: NavigationRailLabelType.all,
      onDestinationSelected: onDestinationSelected,
      backgroundColor: Colors.transparent,
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home_filled),
          label: Text('Home'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.receipt_long_outlined),
          selectedIcon: Icon(Icons.receipt_long),
          label: Text('Transactions'),
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
    );
  }
}

class _AdaptiveBottomNavigation extends StatelessWidget {
  const _AdaptiveBottomNavigation({
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home_filled),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.receipt_long_outlined),
          selectedIcon: Icon(Icons.receipt_long),
          label: 'Transactions',
        ),
        NavigationDestination(
          icon: Icon(Icons.add_circle_outline),
          selectedIcon: Icon(Icons.add_circle),
          label: 'Add Expense',
        ),
        NavigationDestination(
          icon: Icon(Icons.settings_outlined),
          selectedIcon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.label,
    required this.value,
    required this.helper,
    required this.icon,
  });

  final String label;
  final String value;
  final String helper;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      padding: const EdgeInsets.all(20),
      child: Semantics(
        container: true,
        label: '$label. $value. $helper',
        child: Row(
          children: [
            Container(
              height: 52,
              width: 52,
              decoration: BoxDecoration(
                color: const Color(0xFF0F5E56).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: const Color(0xFF0F5E56)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: Color(0xFF63757C),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    helper,
                    style: const TextStyle(
                      color: Color(0xFF63757C),
                      fontSize: 13,
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
}

class _InsightCard extends StatelessWidget {
  const _InsightCard({
    required this.category,
    required this.spent,
    required this.progress,
  });

  final ExpenseCategory category;
  final double spent;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: category.color.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(category.icon, color: category.color),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.name,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${formatCurrency(spent)} of ${formatCurrency(category.monthlyBudget)}',
                      style: const TextStyle(
                        color: Color(0xFF63757C),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                percentageText(progress),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _AccessibleProgressBar(
            value: progress,
            fillColor: category.color,
            trackColor: category.color.withValues(alpha: 0.12),
            label:
                '${category.name} budget progress. ${percentageText(progress)} of the budget has been used.',
          ),
        ],
      ),
    );
  }
}

class _ExpenseListCard extends StatelessWidget {
  const _ExpenseListCard({required this.expense, required this.onTap});

  final ExpenseEntry expense;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final category = categoryFor(expense.category);

    return SurfaceCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Semantics(
        button: true,
        label:
            '${expense.title}, ${formatCurrency(expense.amount)}, ${expense.category}, ${formatLongDate(expense.date)}.',
        child: Row(
          children: [
            Container(
              height: 54,
              width: 54,
              decoration: BoxDecoration(
                color: category.color.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(category.icon, color: category.color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    expense.title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${expense.merchant} • ${formatShortDate(expense.date)}',
                    style: const TextStyle(
                      color: Color(0xFF63757C),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 8,
                    children: [
                      _InfoChip(icon: category.icon, label: expense.category),
                      _InfoChip(
                        icon: Icons.wallet_outlined,
                        label: expense.paymentMethod,
                      ),
                      if (expense.isRecurring)
                        const _InfoChip(
                          icon: Icons.autorenew,
                          label: 'Recurring',
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formatCurrency(expense.amount),
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 18),
                const Icon(Icons.chevron_right, color: Color(0xFF63757C)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterSummaryCard extends StatelessWidget {
  const _FilterSummaryCard({
    required this.totalResults,
    required this.totalAmount,
    required this.activeFilter,
    required this.searchQuery,
    required this.searchController,
    required this.monthlyBudget,
    required this.categories,
    required this.expenses,
    required this.onSearchChanged,
    required this.onFilterSelected,
    required this.filters,
  });

  final int totalResults;
  final double totalAmount;
  final String activeFilter;
  final String searchQuery;
  final TextEditingController searchController;
  final double monthlyBudget;
  final List<ExpenseCategory> categories;
  final List<ExpenseEntry> expenses;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onFilterSelected;
  final List<String> filters;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Search and filters',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          const Text(
            'This side panel demonstrates responsive layout, keyboard-ready inputs, and filter chips.',
            style: TextStyle(
              color: Color(0xFF63757C),
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: searchController,
            onChanged: onSearchChanged,
            decoration: const InputDecoration(
              labelText: 'Search transactions',
              hintText: 'Merchant, title, or notes',
              prefixIcon: Icon(Icons.search),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: filters.map((filter) {
              final selected = filter == activeFilter;
              return ChoiceChip(
                label: Text(filter),
                selected: selected,
                onSelected: (_) => onFilterSelected(filter),
              );
            }).toList(),
          ),
          const SizedBox(height: 18),
          SurfaceCard(
            color: const Color(0xFFEFF4F0),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Current view',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 10),
                _SummaryLine(label: 'Results', value: '$totalResults'),
                _SummaryLine(
                  label: 'Filtered total',
                  value: formatCurrency(totalAmount),
                ),
                _SummaryLine(
                  label: 'Budget coverage',
                  value: percentageText(
                    (totalAmount / monthlyBudget).clamp(0.0, 1.0).toDouble(),
                  ),
                ),
                _SummaryLine(label: 'Filter', value: activeFilter),
                if (searchQuery.trim().isNotEmpty)
                  _SummaryLine(
                    label: 'Search',
                    value: '"${searchQuery.trim()}"',
                  ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Category pressure',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          ...categories.map((category) {
            final spent = spentForCategory(expenses, category.name);
            final progress = (spent / category.monthlyBudget)
                .clamp(0.0, 1.0)
                .toDouble();
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          category.name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        percentageText(progress),
                        style: const TextStyle(
                          color: Color(0xFF63757C),
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  _AccessibleProgressBar(
                    value: progress,
                    fillColor: category.color,
                    trackColor: category.color.withValues(alpha: 0.12),
                    label:
                        '${category.name} uses ${percentageText(progress)} of its assigned budget.',
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _EmptyStateCard extends StatelessWidget {
  const _EmptyStateCard({
    required this.title,
    required this.description,
    required this.actionLabel,
    required this.onAction,
  });

  final String title;
  final String description;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 68,
              width: 68,
              decoration: BoxDecoration(
                color: const Color(0xFF0F5E56).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Icon(
                Icons.search_off_outlined,
                size: 32,
                color: Color(0xFF0F5E56),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              description,
              style: const TextStyle(
                color: Color(0xFF63757C),
                fontSize: 15,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            FilledButton(onPressed: onAction, child: Text(actionLabel)),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  final String title;
  final String subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Color(0xFF63757C),
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        for (final trailingWidget in [trailing].whereType<Widget>())
          trailingWidget,
      ],
    );
  }
}

class _ChecklistItem extends StatelessWidget {
  const _ChecklistItem(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 3),
            child: Icon(
              Icons.check_circle_rounded,
              color: Color(0xFF0F5E56),
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Color(0xFF45565E),
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 4),
            height: 12,
            width: 12,
            decoration: const BoxDecoration(
              color: Color(0xFF0F5E56),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    color: Color(0xFF63757C),
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryLine extends StatelessWidget {
  const _SummaryLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: Color(0xFF63757C), fontSize: 14),
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFD9E0DB)),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 4,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Icon(icon, size: 16, color: const Color(0xFF45565E)),
          Text(
            label,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _AccessibleProgressBar extends StatelessWidget {
  const _AccessibleProgressBar({
    required this.value,
    required this.fillColor,
    required this.trackColor,
    required this.label,
  });

  final double value;
  final Color fillColor;
  final Color trackColor;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(999),
        child: LinearProgressIndicator(
          minHeight: 10,
          value: value,
          backgroundColor: trackColor,
          color: fillColor,
        ),
      ),
    );
  }
}

class SurfaceCard extends StatelessWidget {
  const SurfaceCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(18),
    this.color = Colors.white,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final cardShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(28),
      side: const BorderSide(color: Color(0xFFD9E0DB)),
    );

    return Material(
      color: color,
      elevation: 0,
      shape: cardShape,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}

class ExpenseCategory {
  const ExpenseCategory({
    required this.name,
    required this.icon,
    required this.color,
    required this.monthlyBudget,
  });

  final String name;
  final IconData icon;
  final Color color;
  final double monthlyBudget;
}

class ExpenseEntry {
  const ExpenseEntry({
    required this.id,
    required this.title,
    required this.merchant,
    required this.amount,
    required this.category,
    required this.date,
    required this.note,
    required this.paymentMethod,
    required this.isRecurring,
  });

  final String id;
  final String title;
  final String merchant;
  final double amount;
  final String category;
  final DateTime date;
  final String note;
  final String paymentMethod;
  final bool isRecurring;
}

const List<ExpenseCategory> expenseCategories = [
  ExpenseCategory(
    name: 'Housing',
    icon: Icons.home_work_outlined,
    color: Color(0xFF986BFF),
    monthlyBudget: 1500,
  ),
  ExpenseCategory(
    name: 'Food & Drink',
    icon: Icons.local_cafe_outlined,
    color: Color(0xFFEA7A52),
    monthlyBudget: 450,
  ),
  ExpenseCategory(
    name: 'Transport',
    icon: Icons.directions_bus_outlined,
    color: Color(0xFF2F80ED),
    monthlyBudget: 220,
  ),
  ExpenseCategory(
    name: 'Utilities',
    icon: Icons.bolt_outlined,
    color: Color(0xFF2A9D8F),
    monthlyBudget: 180,
  ),
  ExpenseCategory(
    name: 'Entertainment',
    icon: Icons.movie_creation_outlined,
    color: Color(0xFFC27A35),
    monthlyBudget: 260,
  ),
  ExpenseCategory(
    name: 'Health',
    icon: Icons.favorite_border,
    color: Color(0xFFE25D82),
    monthlyBudget: 180,
  ),
];

final List<ExpenseEntry> sampleExpenses = [
  ExpenseEntry(
    id: '1',
    title: 'Monthly rent',
    merchant: 'Cedar Residence',
    amount: 1250,
    category: 'Housing',
    date: DateTime(2026, 4, 3),
    note: 'Main housing payment for April.',
    paymentMethod: 'Transfer',
    isRecurring: true,
  ),
  ExpenseEntry(
    id: '2',
    title: 'Groceries',
    merchant: 'Fresh Market',
    amount: 86.40,
    category: 'Food & Drink',
    date: DateTime(2026, 4, 16),
    note: 'Weekly groceries with household basics.',
    paymentMethod: 'Card',
    isRecurring: false,
  ),
  ExpenseEntry(
    id: '3',
    title: 'Metro recharge',
    merchant: 'City Transit',
    amount: 42,
    category: 'Transport',
    date: DateTime(2026, 4, 15),
    note: 'Top-up for commuting.',
    paymentMethod: 'Card',
    isRecurring: false,
  ),
  ExpenseEntry(
    id: '4',
    title: 'Streaming bundle',
    merchant: 'BingeBox',
    amount: 19.99,
    category: 'Entertainment',
    date: DateTime(2026, 4, 12),
    note: 'Monthly video and music subscription.',
    paymentMethod: 'Card',
    isRecurring: true,
  ),
  ExpenseEntry(
    id: '5',
    title: 'Internet bill',
    merchant: 'FiberConnect',
    amount: 54.80,
    category: 'Utilities',
    date: DateTime(2026, 4, 10),
    note: 'Home broadband bill.',
    paymentMethod: 'Transfer',
    isRecurring: true,
  ),
  ExpenseEntry(
    id: '6',
    title: 'Pharmacy essentials',
    merchant: 'Wellness Plus',
    amount: 34.20,
    category: 'Health',
    date: DateTime(2026, 4, 8),
    note: 'Cold medicine and vitamins.',
    paymentMethod: 'Cash',
    isRecurring: false,
  ),
];

ExpenseCategory categoryFor(String name) {
  return expenseCategories.firstWhere(
    (category) => category.name == name,
    orElse: () => expenseCategories.first,
  );
}

double spentForCategory(List<ExpenseEntry> expenses, String categoryName) {
  return expenses
      .where((expense) => expense.category == categoryName)
      .fold<double>(0, (sum, expense) => sum + expense.amount);
}

String mostComfortableCategory(
  List<ExpenseCategory> categories,
  List<ExpenseEntry> expenses,
) {
  var bestCategory = categories.first;
  var bestProgress = 999.0;

  for (final category in categories) {
    final progress =
        spentForCategory(expenses, category.name) / category.monthlyBudget;
    if (progress < bestProgress) {
      bestProgress = progress;
      bestCategory = category;
    }
  }

  return bestCategory.name;
}

String formatCurrency(double value) {
  return '\$${value.toStringAsFixed(2)}';
}

String percentageText(double progress) {
  return '${(progress * 100).round()}%';
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
