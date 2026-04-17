part of '../main.dart';

class OverviewScreen extends StatelessWidget {
  const OverviewScreen({
    super.key,
    required this.month,
    required this.entries,
    required this.profile,
    required this.onAddPressed,
    required this.onEntrySelected,
  });

  final DateTime month;
  final List<BudgetEntry> entries;
  final UserProfile profile;
  final VoidCallback onAddPressed;
  final ValueChanged<BudgetEntry> onEntrySelected;

  @override
  Widget build(BuildContext context) {
    final income = totalFor(entries, EntryType.income);
    final spending = totalFor(entries, EntryType.expense);
    final balance = income - spending;
    final remainingBudget = profile.monthlyBudget - spending;
    final savingsAmount = profile.monthlyIncome * (profile.savingsRate / 100);
    final categories = expenseBreakdown(entries).entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final recentEntries = List<BudgetEntry>.from(entries)
      ..sort((a, b) => b.date.compareTo(a.date));
    final upcomingBills = profile.recurringBills.where((bill) {
      final dueDay = parseDueDay(bill.dueLabel);
      return dueDay >= 15;
    }).toList();

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
          child: Semantics(
            button: true,
            label: 'Add transaction for the selected month',
            child: FilledButton.icon(
              onPressed: onAddPressed,
              icon: const Icon(Icons.add),
              label: const Text('Add transaction'),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Budget status',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  remainingBudget >= 0
                      ? 'You are still within your plan for this month.'
                      : 'You are over your planned limit this month.',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  remainingBudget >= 0
                      ? '${formatCurrency(remainingBudget)} available before reaching your spending limit.'
                      : '${formatCurrency(remainingBudget.abs())} above your planned limit.',
                  style: const TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 16),
                LinearProgressIndicator(
                  value: spending == 0
                      ? 0
                      : (spending / profile.monthlyBudget).clamp(0, 1),
                  minHeight: 10,
                  borderRadius: BorderRadius.circular(999),
                  backgroundColor: const Color(0xFFE8ECEF),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _StatusChip(
                      icon: Icons.account_balance_wallet_outlined,
                      label: 'Spent',
                      value: formatCurrency(spending),
                    ),
                    _StatusChip(
                      icon: Icons.savings_outlined,
                      label: 'Saved',
                      value: formatCurrency(savingsAmount),
                    ),
                    _StatusChip(
                      icon: Icons.flag_outlined,
                      label: 'Top expense',
                      value: categories.isEmpty
                          ? 'None yet'
                          : '${categories.first.key} ${formatCurrency(categories.first.value)}',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Upcoming bills',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        if (upcomingBills.isEmpty)
          const _InfoCard(message: 'No more recurring bills due this month.')
        else
          ...upcomingBills.map(
            (bill) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.10),
                    child: Icon(
                      bill.icon,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  title: Text(bill.name),
                  subtitle: Text('Due ${bill.dueLabel}'),
                  trailing: Text(
                    formatCurrency(bill.amount),
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
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
          ...recentEntries.take(5).map(
                (entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: EntryTile(
                    entry: entry,
                    onTap: () => onEntrySelected(entry),
                  ),
                ),
              ),
      ],
    );
  }
}

class EntriesScreen extends StatefulWidget {
  const EntriesScreen({
    super.key,
    required this.month,
    required this.entries,
    required this.onEntrySelected,
  });

  final DateTime month;
  final List<BudgetEntry> entries;
  final ValueChanged<BudgetEntry> onEntrySelected;

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
        Semantics(
          textField: true,
          label: 'Search transactions by name or category',
          child: TextField(
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
              child: EntryTile(
                entry: entry,
                onTap: () => widget.onEntrySelected(entry),
              ),
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
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      helperText: 'Example: Groceries, Rent, Salary',
                    ),
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

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    super.key,
    required this.profile,
    required this.currentMonthEntries,
  });

  final UserProfile profile;
  final List<BudgetEntry> currentMonthEntries;

  @override
  Widget build(BuildContext context) {
    final spent = totalFor(currentMonthEntries, EntryType.expense);
    final remainingBudget = profile.monthlyBudget - spent;
    final savingsAmount = profile.monthlyIncome * (profile.savingsRate / 100);
    final recurringTotal = profile.recurringBills.fold<double>(
      0,
      (sum, bill) => sum + bill.amount,
    );
    final recurringRatio = profile.monthlyIncome == 0
        ? 0.0
        : recurringTotal / profile.monthlyIncome;
    final double spendingProgress = profile.monthlyBudget == 0
        ? 0.0
        : (spent / profile.monthlyBudget).clamp(0, 1);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: const LinearGradient(
              colors: [Color(0xFF143E35), Color(0xFF2A7565)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Color(0x33FFFFFF),
                    child: Icon(Icons.person, color: Colors.white, size: 30),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profile.name,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${profile.email} - ${profile.city}',
                          style: const TextStyle(color: Color(0xD9FFFFFF)),
                        ),
                      ],
                    ),
                  ),
                  FilledButton.tonal(
                    onPressed: () {},
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0x33FFFFFF),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Manage'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Available to spend',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xCCFFFFFF),
                    ),
              ),
              const SizedBox(height: 6),
              Text(
                formatCurrency(remainingBudget),
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Spent ${formatCurrency(spent)} of ${formatCurrency(profile.monthlyBudget)} planned this month.',
                style: const TextStyle(color: Color(0xD9FFFFFF), height: 1.4),
              ),
              const SizedBox(height: 14),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: spendingProgress,
                  minHeight: 10,
                  backgroundColor: const Color(0x26FFFFFF),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFFE8F4F0),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _ActionBadge(
                    icon: Icons.account_balance_wallet_outlined,
                    label: 'Spending plan',
                  ),
                  _ActionBadge(
                    icon: Icons.credit_card_outlined,
                    label: 'Payment methods',
                  ),
                  _ActionBadge(
                    icon: Icons.notifications_none,
                    label: 'Bill reminders',
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Financial snapshot',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final cards = [
              _SummaryCard(
                label: 'Planned spending limit',
                value: formatCurrency(profile.monthlyBudget),
                tone: const Color(0xFFF2EADB),
                valueColor: const Color(0xFF7A5A16),
              ),
              _SummaryCard(
                label: 'Remaining to spend',
                value: formatCurrency(remainingBudget),
                tone: remainingBudget >= 0
                    ? const Color(0xFFE7F6EF)
                    : const Color(0xFFFDEFE9),
                valueColor: remainingBudget >= 0
                    ? const Color(0xFF1F7A46)
                    : const Color(0xFFB8572A),
              ),
              _SummaryCard(
                label: 'Emergency savings',
                value: formatCurrency(profile.emergencyFund),
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
        const SizedBox(height: 20),
        LayoutBuilder(
          builder: (context, constraints) {
            final details = [
              _ProfileMetricCard(
                icon: Icons.savings_outlined,
                title: 'Saved this month',
                value: '${profile.savingsRate}%',
                subtitle: 'Share of this month\'s income already moved to savings',
              ),
              _ProfileMetricCard(
                icon: Icons.credit_score_outlined,
                title: 'Credit card usage',
                value: profile.creditScoreBand,
                subtitle: 'How close current card spending is to the safe limit',
              ),
              _ProfileMetricCard(
                icon: Icons.receipt_long_outlined,
                title: 'Bills due every month',
                value: '${(recurringRatio * 100).round()}% of income',
                subtitle: 'Income committed before groceries, transport, and extras',
              ),
            ];

            if (constraints.maxWidth >= 900) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < details.length; i++) ...[
                    Expanded(child: details[i]),
                    if (i != details.length - 1) const SizedBox(width: 12),
                  ],
                ],
              );
            }

            return Column(
              children: [
                for (var i = 0; i < details.length; i++) ...[
                  details[i],
                  if (i != details.length - 1) const SizedBox(height: 12),
                ],
              ],
            );
          },
        ),
        const SizedBox(height: 20),
        Text(
          'Account overview',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        Card(
          child: Column(
            children: [
              _DetailRow(label: 'Current goal', value: profile.primaryGoal),
              const Divider(height: 1),
              _DetailRow(
                label: 'Household size',
                value: '${profile.householdSize} people',
              ),
              const Divider(height: 1),
              _DetailRow(label: 'Next payday', value: profile.paydayLabel),
              const Divider(height: 1),
              _DetailRow(
                label: 'Card usage',
                value: profile.creditScoreBand,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Monthly routine',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        Card(
          child: Column(
            children: [
              _DetailRow(
                label: 'Monthly income',
                value: formatCurrency(profile.monthlyIncome),
              ),
              const Divider(height: 1),
              _DetailRow(
                label: 'Recurring bills',
                value: formatCurrency(recurringTotal),
              ),
              const Divider(height: 1),
              _DetailRow(
                label: 'Savings transfer',
                value: formatCurrency(savingsAmount),
              ),
              const Divider(height: 1),
              _DetailRow(
                label: 'Bills ratio',
                value: '${(recurringRatio * 100).round()}% of income',
              ),
              const Divider(height: 1),
              _DetailRow(
                label: 'Budget status',
                value: remainingBudget >= 0
                    ? '${formatCurrency(remainingBudget)} left'
                    : '${formatCurrency(remainingBudget.abs())} over',
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Payment methods',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        ...profile.paymentMethods.map(
          (method) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: method.color.withValues(alpha: 0.14),
                  child: Icon(method.icon, color: method.color),
                ),
                title: Text(method.label),
                subtitle: Text(method.detail),
                trailing: const Icon(Icons.chevron_right),
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          'Recurring bills',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        ...profile.recurringBills.map(
          (bill) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Card(
              child: ListTile(
                leading: Icon(
                  bill.icon,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Text(bill.name),
                subtitle: Text('Due ${bill.dueLabel}'),
                trailing: Text(
                  formatCurrency(bill.amount),
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        const _InfoCard(
          message:
              'This profile view is grouped like a real finance app: identity, monthly money habits, payment methods, and recurring costs are all in one place.',
        ),
      ],
    );
  }
}

class EntryDetailScreen extends StatelessWidget {
  const EntryDetailScreen({super.key, required this.entry});

  final BudgetEntry entry;

  @override
  Widget build(BuildContext context) {
    final valueColor = entry.isIncome
        ? const Color(0xFF1F7A46)
        : const Color(0xFFB8572A);

    return Scaffold(
      appBar: AppBar(title: const Text('Transaction details')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Semantics(
            header: true,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: valueColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        entry.isIncome ? 'Income' : 'Expense',
                        style: TextStyle(
                          color: valueColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      entry.title,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${entry.category} - ${formatLongDate(entry.date)}',
                      style: const TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      '${entry.isIncome ? '+' : '-'}${formatCurrency(entry.amount)}',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            color: valueColor,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                _DetailRow(label: 'Category', value: entry.category),
                const Divider(height: 1),
                _DetailRow(
                  label: 'Type',
                  value: entry.isIncome ? 'Income' : 'Expense',
                ),
                const Divider(height: 1),
                _DetailRow(label: 'Date', value: formatLongDate(entry.date)),
                const Divider(height: 1),
                _DetailRow(
                  label: 'Amount',
                  value: formatCurrency(entry.amount),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Notes',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    entry.note.trim().isEmpty
                        ? 'No additional note was added for this transaction.'
                        : entry.note,
                    style: const TextStyle(height: 1.4),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    super.key,
    required this.profile,
    required this.isDarkMode,
    required this.monthlyReminder,
    required this.carryOverPlan,
    required this.compactNumbers,
    required this.billAlerts,
    required this.biometricLock,
    required this.onThemeModeChanged,
    required this.onMonthlyReminderChanged,
    required this.onCarryOverPlanChanged,
    required this.onCompactNumbersChanged,
    required this.onBillAlertsChanged,
    required this.onBiometricLockChanged,
  });

  final UserProfile profile;
  final bool isDarkMode;
  final bool monthlyReminder;
  final bool carryOverPlan;
  final bool compactNumbers;
  final bool billAlerts;
  final bool biometricLock;
  final ValueChanged<bool> onThemeModeChanged;
  final ValueChanged<bool> onMonthlyReminderChanged;
  final ValueChanged<bool> onCarryOverPlanChanged;
  final ValueChanged<bool> onCompactNumbersChanged;
  final ValueChanged<bool> onBillAlertsChanged;
  final ValueChanged<bool> onBiometricLockChanged;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Keep the prototype practical and focused on planning.',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.black54),
        ),
        const SizedBox(height: 16),
        Text(
          'Profile and account',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.person_outline),
                ),
                title: Text(profile.name),
                subtitle: Text('${profile.email}\n${profile.city}'),
                isThreeLine: true,
                trailing: const Icon(Icons.chevron_right),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.payments_outlined),
                title: const Text('Next payday'),
                subtitle: Text(profile.paydayLabel),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.flag_outlined),
                title: const Text('Current goal'),
                subtitle: Text(profile.primaryGoal),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Notifications',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        Card(
          child: Column(
            children: [
              SwitchListTile.adaptive(
                title: const Text('Monthly reminder'),
                subtitle: const Text(
                  'Prompt the user to review progress each month.',
                ),
                value: monthlyReminder,
                onChanged: onMonthlyReminderChanged,
              ),
              const Divider(height: 1),
              SwitchListTile.adaptive(
                title: const Text('Upcoming bill alerts'),
                subtitle: const Text(
                  'Warn the user before recurring bills are due.',
                ),
                value: billAlerts,
                onChanged: onBillAlertsChanged,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Budgeting preferences',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        Card(
          child: Column(
            children: [
              SwitchListTile.adaptive(
                title: const Text('Carry over remaining balance'),
                subtitle: const Text(
                  'Use leftover budget as a starting point next month.',
                ),
                value: carryOverPlan,
                onChanged: onCarryOverPlanChanged,
              ),
              const Divider(height: 1),
              SwitchListTile.adaptive(
                title: const Text('Compact numbers'),
                subtitle: const Text(
                  'Show shorter totals in dashboards and cards.',
                ),
                value: compactNumbers,
                onChanged: onCompactNumbersChanged,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Appearance and privacy',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        Card(
          child: Column(
            children: [
              SwitchListTile.adaptive(
                title: const Text('Dark mode'),
                subtitle: Text(
                  isDarkMode
                      ? 'Use the darker theme throughout the app.'
                      : 'Use the lighter theme throughout the app.',
                ),
                value: isDarkMode,
                onChanged: onThemeModeChanged,
              ),
              const Divider(height: 1),
              SwitchListTile.adaptive(
                title: const Text('Biometric lock'),
                subtitle: const Text(
                  'Require fingerprint or face unlock to open the app.',
                ),
                value: biometricLock,
                onChanged: onBiometricLockChanged,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const _InfoCard(
          message:
              'This prototype stores sample data in memory only. The settings are included to demonstrate realistic finance-app preferences, accessibility awareness, and user testing flows.',
        ),
      ],
    );
  }
}
