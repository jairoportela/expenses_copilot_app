class MonthlySummary {
  const MonthlySummary({
    required this.id,
    required this.totalIncomes,
    required this.totalExpenses,
    required this.incomesPercentage,
    required this.expensesPercentage,
    required this.balance,
    required this.month,
  });
  final double totalIncomes;
  final double totalExpenses;
  final double balance;
  final double incomesPercentage;
  final double expensesPercentage;
  final DateTime month;
  final String id;

  factory MonthlySummary.fromJson(Map<String, dynamic> json) {
    final totalExpenses =
        double.tryParse((json['total_expenses'] ?? '').toString()) ?? 0.0;
    final totalIncomes =
        double.tryParse((json['total_incomes'] ?? '').toString()) ?? 0.0;
    final totalBalance =
        double.tryParse((json['total_balance'] ?? '').toString()) ?? 0.0;

    final totalSum = totalIncomes.abs() + totalExpenses.abs();
    final incomesPercentage =
        totalSum == 0 ? 0.0 : totalIncomes.abs() / totalSum;
    final expensesPercentage =
        totalSum == 0 ? 0.0 : totalExpenses.abs() / totalSum;

    return MonthlySummary(
      id: json['id'],
      month: DateTime.tryParse(json['month'] ?? '') ?? DateTime.now(),
      totalExpenses: totalExpenses,
      totalIncomes: totalIncomes,
      expensesPercentage: expensesPercentage,
      incomesPercentage: incomesPercentage,
      balance: totalBalance,
    );
  }

  factory MonthlySummary.empty(DateTime month) => MonthlySummary(
        id: '',
        totalIncomes: 0,
        totalExpenses: 0,
        incomesPercentage: 0,
        expensesPercentage: 0,
        balance: 0,
        month: month,
      );
}
