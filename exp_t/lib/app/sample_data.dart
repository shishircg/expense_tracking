part of '../main.dart';

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

const UserProfile sampleProfile = UserProfile(
  name: 'Mia Carter',
  email: 'mia.carter@example.com',
  city: 'Kathmandu',
  monthlyBudget: 2100,
  monthlyIncome: 3680,
  emergencyFund: 6400,
  savingsRate: 18,
  creditScoreBand: '31% of limit used',
  paydayLabel: 'May 1',
  householdSize: 2,
  primaryGoal: 'Save for travel and keep rent under 30% of income',
  paymentMethods: [
    PaymentMethod(
      label: 'Everyday checking',
      detail: 'Used for rent, utilities, and daily spending',
      icon: Icons.account_balance_outlined,
      color: Color(0xFF3059B8),
    ),
    PaymentMethod(
      label: 'Cashback card',
      detail: 'Paid in full monthly - Limit \$3,000',
      icon: Icons.credit_card_outlined,
      color: Color(0xFF7A5A16),
    ),
    PaymentMethod(
      label: 'Emergency savings',
      detail: 'Separate account reserved for unexpected costs',
      icon: Icons.shield_outlined,
      color: Color(0xFF1F7A46),
    ),
  ],
  recurringBills: [
    RecurringBill(
      name: 'Rent',
      amount: 1100,
      dueLabel: '2nd of each month',
      icon: Icons.home_outlined,
    ),
    RecurringBill(
      name: 'Electricity and water',
      amount: 120,
      dueLabel: '10th of each month',
      icon: Icons.bolt_outlined,
    ),
    RecurringBill(
      name: 'Internet',
      amount: 45,
      dueLabel: '15th of each month',
      icon: Icons.wifi_outlined,
    ),
    RecurringBill(
      name: 'Health insurance',
      amount: 160,
      dueLabel: '20th of each month',
      icon: Icons.favorite_border,
    ),
  ],
);
