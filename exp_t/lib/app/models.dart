part of '../main.dart';

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

class UserProfile {
  const UserProfile({
    required this.name,
    required this.email,
    required this.city,
    required this.monthlyBudget,
    required this.monthlyIncome,
    required this.emergencyFund,
    required this.savingsRate,
    required this.creditScoreBand,
    required this.paydayLabel,
    required this.householdSize,
    required this.primaryGoal,
    required this.paymentMethods,
    required this.recurringBills,
  });

  final String name;
  final String email;
  final String city;
  final double monthlyBudget;
  final double monthlyIncome;
  final double emergencyFund;
  final int savingsRate;
  final String creditScoreBand;
  final String paydayLabel;
  final int householdSize;
  final String primaryGoal;
  final List<PaymentMethod> paymentMethods;
  final List<RecurringBill> recurringBills;
}

class PaymentMethod {
  const PaymentMethod({
    required this.label,
    required this.detail,
    required this.icon,
    required this.color,
  });

  final String label;
  final String detail;
  final IconData icon;
  final Color color;
}

class RecurringBill {
  const RecurringBill({
    required this.name,
    required this.amount,
    required this.dueLabel,
    required this.icon,
  });

  final String name;
  final double amount;
  final String dueLabel;
  final IconData icon;
}
